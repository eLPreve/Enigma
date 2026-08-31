import Foundation

/// Modello di configurazione della macchina Enigma M3.
public struct EnigmaConfiguration {
    /// Ordine dei rotori, dal primo (veloce) all'ultimo (lento). Es. `["1","2","3"]`.
    public var rotorOrder: [Character]
    /// Posizioni iniziali dei rotori mostrate nelle finestrelle, valori 1…26 (1 = A).
    public var positions: [Int]
    /// Ring settings (Ringstellung), valori 1…26 (1 = A, nessun offset).
    public var ringSettings: [Int]
    /// Riflettore: `"B"` o `"C"`.
    public var reflector: Character
    /// Coppie della plugboard (es. `["AB", "CD"]`).
    public var plugboardPairs: [String]

    public init(
        rotorOrder: [Character] = ["1", "2", "3"],
        positions: [Int] = [1, 1, 1],
        ringSettings: [Int] = [1, 1, 1],
        reflector: Character = "B",
        plugboardPairs: [String] = []
    ) {
        self.rotorOrder = rotorOrder
        self.positions = positions
        self.ringSettings = ringSettings
        self.reflector = reflector
        self.plugboardPairs = plugboardPairs
    }

    /// Impostazioni di default: ordine 123, posizioni 1,1,1, anelli 1,1,1, riflettore B.
    public static let `default` = EnigmaConfiguration()
}

/// Simulatore della macchina Enigma M3 (Wehrmacht), storicamente fedele.
///
/// Porting del modello di py-enigma (Brian Neal, MIT): stepping meccanico con
/// intaglio (turnover) e double stepping del rotore di mezzo, ring settings,
/// riflettori B/C e plugboard. Enigma è simmetrica: con le stesse impostazioni,
/// cifrare due volte un testo restituisce l'originale (cifratura = decifratura).
///
/// - Importante: questo è il comportamento REALE dell'M3. L'app Android
///   originale (2014/2015) non aveva intagli/ring settings (scattava solo il
///   primo rotore): quella variante è documentata in `reference_enigma.py`.
public struct EnigmaMachine {
    /// Rotori in ordine di montaggio (veloce → lento); `rotors[0]` è il veloce.
    private(set) var rotors: [Rotor]
    /// Pannello a prese multiple.
    private var plugboard: Plugboard
    /// Riflettore.
    private var reflector: Reflector

    public init(configuration: EnigmaConfiguration = .default) {
        self.init(
            rotorOrder: configuration.rotorOrder,
            positions: configuration.positions,
            ringSettings: configuration.ringSettings,
            reflectorName: configuration.reflector,
            plugboardPairs: configuration.plugboardPairs
        )
    }

    public init(
        rotorOrder: [Character],
        positions: [Int],
        ringSettings: [Int] = [1, 1, 1],
        reflectorName: Character,
        plugboardPairs: [String]
    ) {
        // PLUGBOARD
        var board = Plugboard()
        for pair in plugboardPairs {
            board.configure(pair)
        }
        self.plugboard = board

        // ROTORI (veloce → lento), con ring setting e posizioni iniziali.
        var rotors = [Rotor]()
        for i in 0..<rotorOrder.count {
            let ring = (i < ringSettings.count ? ringSettings[i] : 1) - 1
            var rotor = Rotor(name: rotorOrder[i], ringSetting: ((ring % 26) + 26) % 26)
            let pos = (i < positions.count ? positions[i] : 1) - 1
            rotor.setDisplay(((pos % 26) + 26) % 26)
            rotors.append(rotor)
        }
        self.rotors = rotors

        // RIFLETTORE
        self.reflector = Reflector(name: reflectorName)
    }

    /// Lettere attualmente mostrate nelle finestrelle (veloce → lento).
    public var display: [Character] {
        rotors.map { Character(UnicodeScalar($0.display + 65)!) }
    }

    /// Cifra (o decifra) il testo. Le lettere vengono convertite in maiuscolo;
    /// i caratteri non alfabetici vengono ignorati.
    public func encrypt(_ text: String) -> String {
        var machine = self
        var output = ""

        for ch in text.uppercased() {
            guard ch.isLetter, ch.isASCII else { continue }
            output.append(machine.keyPress(ch))
        }

        return output
    }

    /// Simula la pressione di un tasto sulla tastiera: prima lo stepping
    /// meccanico, poi il segnale elettrico attraverso la macchina. Restituisce
    /// la lampadina che si accende (la lettera cifrata).
    ///
    /// Sequenza identica a py-enigma:
    ///   1. stepping: il rotore veloce avanza sempre; il rotore di mezzo avanza
    ///      se il veloce è sull'intaglio oppure se è esso stesso sull'intaglio
    ///      (double stepping); il rotore lento avanza se il rotore di mezzo è
    ///      sull'intaglio.
    ///   2. segnale: plugboard → rotori (destra→sinistra) → riflettore →
    ///      rotori (sinistra→destra) → plugboard.
    public mutating func keyPress(_ key: Character) -> Character {
        // --- STEPPING MECCANICO (prima della cifratura) ---
        let fast = rotors[0]
        let middle = rotors[1]
        let rotateMiddle = fast.isAtNotch() || middle.isAtNotch()
        let rotateSlow = middle.isAtNotch()
        rotors[0].step()
        if rotateMiddle { rotors[1].step() }
        if rotateSlow { rotors[2].step() }

        // --- SEGNALE ELETTRICO ---
        var signal = Int(key.asciiValue!) - 65
        signal = plugboard.signal(signal)
        for i in 0..<rotors.count {                    // destra → sinistra (veloce → lento)
            signal = rotors[i].signalIn(signal)
        }
        signal = reflector.signalIn(signal)            // riflettore
        for i in stride(from: rotors.count - 1, through: 0, by: -1) {  // sinistra → destra
            signal = rotors[i].signalOut(signal)
        }
        signal = plugboard.signal(signal)              // plugboard (uscita)

        return Character(UnicodeScalar(signal + 65)!)
    }
}
