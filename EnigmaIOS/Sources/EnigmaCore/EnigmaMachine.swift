import Foundation

/// Modello di configurazione della macchina Enigma.
public struct EnigmaConfiguration {
    /// Ordine dei rotori, dal primo (veloce) all'ultimo. Es. `["1","2","3"]`.
    /// Corrisponde alla stringa `Ord_R` dell'originale.
    public var rotorOrder: [Character]
    /// Posizioni iniziali dei rotori, valori 1…26 (1 = A, 26 = Z).
    public var positions: [Int]
    /// Riflettore: `"B"` o `"C"`.
    public var reflector: Character
    /// Coppie della plugboard (es. `["AB", "CD"]`).
    public var plugboardPairs: [String]

    public init(
        rotorOrder: [Character] = ["1", "2", "3"],
        positions: [Int] = [1, 1, 1],
        reflector: Character = "B",
        plugboardPairs: [String] = []
    ) {
        self.rotorOrder = rotorOrder
        self.positions = positions
        self.reflector = reflector
        self.plugboardPairs = plugboardPairs
    }

    /// Impostazioni di default (come nell'app originale: ordine 123, posizioni 1,1,1, riflettore B).
    public static let `default` = EnigmaConfiguration()
}

/// Simulatore della macchina Enigma.
///
/// Porting fedele dell'algoritmo di `MainActivity.java` dell'app Android
/// originale. Enigma è simmetrica: con le stesse impostazioni, cifrare due
/// volte un testo restituisce il testo originale (cifratura = decifratura).
///
/// - Importante: replica il comportamento *originale* (il primo rotore
///   dell'ordine è quello veloce e scatta dopo ogni lettera). I miglioramenti
///   di fedeltà storica (notch, double stepping, ring settings) verranno
///   aggiunti successivamente.
public struct EnigmaMachine {
    /// Rotori in ordine di montaggio; `rotors[0]` è il rotore veloce.
    private(set) var rotors: [Rotor]
    /// Pannello a prese multiple.
    private var plugboard: Plugboard
    /// Riflettore.
    private var reflector: Reflector

    public init(configuration: EnigmaConfiguration = .default) {
        self.init(
            rotorOrder: configuration.rotorOrder,
            positions: configuration.positions,
            reflectorName: configuration.reflector,
            plugboardPairs: configuration.plugboardPairs
        )
    }

    public init(
        rotorOrder: [Character],
        positions: [Int],
        reflectorName: Character,
        plugboardPairs: [String]
    ) {
        // PLUGBOARD
        var board = Plugboard()
        for pair in plugboardPairs {
            board.configure(pair)
        }
        self.plugboard = board

        // ROTORI (in ordine di montaggio)
        self.rotors = rotorOrder.map { Rotor(name: $0) }

        // POSIZIONI INIZIALI (stessa logica dell'originale: si ruota finché
        // la prima lettera della faccia destra non coincide con quella voluta)
        for i in 0..<rotors.count {
            let target = Character(UnicodeScalar(positions[i] + 64)!)
            for _ in 0..<26 {
                if rotors[i].letter(at: 0, on: .right) != target {
                    rotors[i].step()
                }
            }
        }

        // RIFLETTORE
        self.reflector = Reflector(name: reflectorName)
    }

    /// Cifra (o decifra) il testo. Le lettere vengono convertite in maiuscolo;
    /// i caratteri non alfabetici vengono ignorati (come nell'originale, che
    /// rimuoveva gli spazi).
    public func encrypt(_ text: String) -> String {
        let alphabet = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")

        // Copia mutabile locale: lo stepping dei rotori è parte della cifratura,
        // ma vogliamo che `self` resti invariata tra una chiamata e l'altra.
        var machine = self
        var output = ""

        for ch in text.uppercased() {
            guard ch.isLetter, ch.isASCII else { continue }
            var letter = ch

            // PLUGBOARD (andata)
            letter = machine.plugboard.swap(letter)

            // ROTORE STATICO (identità) + ingresso nel primo rotore per indice
            let entryIndex = Int(letter.asciiValue!) - 65
            letter = machine.rotors[0].letter(at: entryIndex, on: .right)

            // ROTORI (andata): destra -> sinistra
            for j in 0..<machine.rotors.count {
                let index = machine.rotors[j].contact(letter, on: .right)
                letter = machine.rotors[j].letter(at: index, on: .left)
            }

            // RIFLETTORE
            let reflectorIndex = machine.reflector.contact(letter, on: .right)
            letter = machine.reflector.letter(at: reflectorIndex, on: .left)

            // ROTORI (ritorno): sinistra -> destra
            for j in stride(from: machine.rotors.count - 1, through: 0, by: -1) {
                let index = machine.rotors[j].contact(letter, on: .left)
                letter = machine.rotors[j].letter(at: index, on: .right)
            }

            // ROTORE STATICO (uscita): ritrova l'indice sul primo rotore e
            // restituisce la lettera identità a quell'indice.
            let exitIndex = machine.rotors[0].contact(letter, on: .right)
            letter = alphabet[exitIndex]

            // PLUGBOARD (ritorno)
            letter = machine.plugboard.swap(letter)

            output.append(letter)

            // MOVIMENTO PERIODICO: scatta il primo rotore (quello veloce)
            machine.rotors[0].step()
        }

        return output
    }
}
