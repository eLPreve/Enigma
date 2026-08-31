import Foundation

/// Riflettore (UKW) di una Enigma M3: B o C.
///
/// A differenza dei rotori, il riflettore non ruota e non ha ring setting: è
/// una semplice mappa di cablaggio (nessuna lettera è collegata a sé stessa,
/// così Enigma è simmetrica: cifrare due volte con le stesse impostazioni
/// restituisce l'originale).
public struct Reflector {
    /// Nome del riflettore: `"B"` o `"C"`.
    public let name: Character

    /// Cablaggio: `wiring[n]` = contatto collegato a `n` (0-25).
    private let wiring: [Int]
    /// Cablaggio inverso (per il percorso di ritorno).
    private let exitMap: [Int]

    public init(name: Character) {
        self.name = name
        let s: String
        switch name {
        case "B": s = "YRUHQSLDPXNGOKMIEBFZCWVJAT"
        case "C": s = "FVPJIAOYEDRZXWGCTKUQSBNMHL"
        default:  s = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        }
        self.wiring = s.map { Int($0.asciiValue!) - 65 }
        var exit = [Int](repeating: 0, count: 26)
        for (i, v) in wiring.enumerated() { exit[v] = i }
        self.exitMap = exit
    }

    /// Segnale in ingresso da destra (pin) → contatto di sinistra.
    public func signalIn(_ n: Int) -> Int {
        wiring[n]
    }

    /// Segnale in ingresso da sinistra (contatto) → pin di destra.
    public func signalOut(_ n: Int) -> Int {
        exitMap[n]
    }
}
