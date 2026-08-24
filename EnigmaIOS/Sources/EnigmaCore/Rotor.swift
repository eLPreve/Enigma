import Foundation

/// Faccia di un rotore (o riflettore).
public enum Face {
    /// Faccia destra: alfabeto ordinato quando il rotore non è ruotato.
    case right
    /// Faccia sinistra: contiene le lettere con cui avvengono gli scambi (cablaggio).
    case left
}

/// Rappresenta uno dei rotori della macchina Enigma.
///
/// Porting fedele della classe `Rotore` dell'app Android originale
/// (`MyApplication/app/src/main/java/com/example/nik/myapplication/Rotore.java`):
/// stesso modello, stesse tabelle di cablaggio (rotori I–V), stesso comportamento
/// di `scatta()` (rotazione a sinistra di una posizione su entrambe le facce).
public struct Rotor {
    /// Nome del rotore: `"1"`…`"5"` (rotori I…V). Qualsiasi altro valore
    /// (es. `"0"`) produce il "rotore statico" dell'originale: faccia destra
    /// azzerata, faccia sinistra identità.
    public let name: Character

    /// Contatti sulla faccia destra (alfabeto ordinato quando non ruotato).
    private var right: [Character]
    /// Contatti sulla faccia sinistra (lettere con cui avvengono gli scambi).
    private var left: [Character]

    public init(name: Character) {
        self.name = name
        self.right = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        self.left = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")

        switch name {
        case "1": self.left = Array("EKMFLGDQVZNTOWYHXUSPAIBRCJ")
        case "2": self.left = Array("AJDKSIRUXBLHWTMCQGZNPYFVOE")
        case "3": self.left = Array("BDFHJLCPRTXVZNYEIWGAKMUSQO")
        case "4": self.left = Array("ESOVPZJAYQUIRHXLNFTGKDCMWB")
        case "5": self.left = Array("VZBRGITYUPSDNHLXAWMJQOFECK")
        default:
            // Rotore statico: come nell'originale, la faccia destra viene azzerata.
            self.right = Array(repeating: "0", count: 26)
        }
    }

    /// Fa "scattare" il rotore: ruota di una posizione entrambe le facce.
    public mutating func step() {
        right.append(right.removeFirst())
        left.append(left.removeFirst())
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
