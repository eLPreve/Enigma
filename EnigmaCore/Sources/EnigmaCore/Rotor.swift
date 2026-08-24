import Foundation

/// Rotore di una Enigma M3 (Wehrmacht), con comportamento storicamente fedele.
///
/// Porting del modello di py-enigma (Brian Neal, MIT License): ogni rotore ha
/// un cablaggio, un intaglio (turnover), un ring setting (Ringstellung) e una
/// posizione. `entryMap[pin]` è il contatto di sinistra collegato al pin di
/// destra `pin` (indici 0-25).
///
/// I rotori I–V erano usati da Heer, Luftwaffe e Kriegsmarine; il modello M4
/// aggiungeva Beta/Gamma (non in questo simulatore, che replica l'M3).
public struct Rotor {
    /// Nome del rotore: `"1"`…`"5"` (rotori I–V). Qualsiasi altro valore
    /// (es. `"0"`) produce il rotore "statico" (identità, senza intaglio),
    /// utile come entry wheel / riferimento.
    public let name: Character

    /// Cablaggio: `entryMap[pin]` = contatto di sinistra collegato a `pin` (0-25).
    private let entryMap: [Int]
    /// Cablaggio inverso: `exitMap[contact]` = pin di destra (0-25).
    private let exitMap: [Int]
    /// Lettere (indice 0-25) in cui l'intaglio è allineato con la leva (pawl).
    private let notches: Set<Int>
    /// Posizione interna del rotore sull'asse (0-25).
    public private(set) var pos: Int
    /// Lettera mostrata nella finestrella (0-25).
    public private(set) var display: Int
    /// Anello (Ringstellung), 0-25 (0 = A, nessun offset).
    public let ringSetting: Int

    /// Tabelle di cablaggio e intaglio dei rotori I–V (dati storici, Rijmenants).
    /// Il rotore statico (`"0"`/default) è l'identità senza intaglio.
    private static func table(for name: Character) -> (wiring: String, notch: Character?) {
        switch name {
        case "1": return ("EKMFLGDQVZNTOWYHXUSPAIBRCJ", "Q")
        case "2": return ("AJDKSIRUXBLHWTMCQGZNPYFVOE", "E")
        case "3": return ("BDFHJLCPRTXVZNYEIWGAKMUSQO", "V")
        case "4": return ("ESOVPZJAYQUIRHXLNFTGKDCMWB", "J")
        case "5": return ("VZBRGITYUPSDNHLXAWMJQOFECK", "Z")
        default:  return ("ABCDEFGHIJKLMNOPQRSTUVWXYZ", nil)
        }
    }

    public init(name: Character, ringSetting: Int = 0) {
        self.name = name
        self.ringSetting = ringSetting
        self.pos = 0
        self.display = 0

        let (wiring, notch) = Self.table(for: name)
        self.entryMap = wiring.map { Int($0.asciiValue!) - 65 }
        var exit = [Int](repeating: 0, count: 26)
        for (i, v) in entryMap.enumerated() { exit[v] = i }
        self.exitMap = exit
        if let notch {
            self.notches = [Int(notch.asciiValue!) - 65]
        } else {
            self.notches = []
        }

        // Come py-enigma: all'avvio la finestrella mostra "A".
        self.setDisplay(0)
    }

    /// Imposta la lettera mostrata nella finestrella (0-25).
    public mutating func setDisplay(_ letter: Int) {
        pos = ((letter - ringSetting) % 26 + 26) % 26
        display = letter
    }

    /// Segnale che entra da destra (pin) ed esce a sinistra (contatto). `n` in 0-25.
    public func signalIn(_ n: Int) -> Int {
        let pin = (n + pos) % 26
        let contact = entryMap[pin]
        return ((contact - pos) % 26 + 26) % 26
    }

    /// Segnale che entra da sinistra (contatto) ed esce a destra (pin). `n` in 0-25.
    public func signalOut(_ n: Int) -> Int {
        let contact = (n + pos) % 26
        let pin = exitMap[contact]
        return ((pin - pos) % 26 + 26) % 26
    }

    /// True se l'intaglio è allineato con la leva (la lettera mostrata è quella
    /// dell'intaglio): al prossimo tasto farà avanzare il rotore alla sua sinistra.
    public func isAtNotch() -> Bool {
        notches.contains(display)
    }

    /// Avanza di una posizione per azione meccanica (pawl).
    public mutating func step() {
        pos = (pos + 1) % 26
        display = (pos + ringSetting) % 26
    }
}
