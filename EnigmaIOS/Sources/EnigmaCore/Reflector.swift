import Foundation

/// Rappresenta il riflettore della macchina Enigma (B o C).
///
/// Porting fedele della classe `Reflector` dell'app Android originale.
/// Molto simile a `Rotor`: la faccia destra è l'alfabeto ordinato, la faccia
/// sinistra contiene la mappa degli scambi (nessuna lettera è scambiata con sé stessa).
public struct Reflector {
    /// Nome del riflettore: `"B"` o `"C"`.
    public let name: Character

    /// Faccia destra: alfabeto ordinato (ingresso).
    private var right: [Character]
    /// Faccia sinistra: mappa degli scambi.
    private var left: [Character]

    public init(name: Character) {
        self.name = name
        self.right = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        self.left = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")

        switch name {
        case "B": self.left = Array("YRUHQSLDPXNGOKMIEBFZCWVJAT")
        case "C": self.left = Array("FVPJIAOYEDRZXWGCTKUQSBNMHL")
        default:
            self.left = Array(repeating: "0", count: 26)
        }
    }

    /// Trova l'indice in cui compare la lettera `x` sulla faccia indicata.
    public func contact(_ x: Character, on face: Face) -> Int {
        let array = face == .right ? right : left
        return array.firstIndex(of: x) ?? 0
    }

    /// Restituisce la lettera alla posizione `index` sulla faccia indicata.
    public func letter(at index: Int, on face: Face) -> Character {
        let array = face == .right ? right : left
        return array[index]
    }
}
