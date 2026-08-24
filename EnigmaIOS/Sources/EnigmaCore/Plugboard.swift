import Foundation

/// Rappresenta il pannello a prese multiple (plugboard) della macchina Enigma.
///
/// Porting fedele della classe `Plugboard` dell'app Android originale:
/// due vettori paralleli dove `left[i]` è la lettera in ingresso e `right[i]`
/// la lettera con cui viene scambiata. Le coppie vengono configurate con
/// `configure(_:)` (es. `"AB"` scambia A con B e B con A).
public struct Plugboard {
    /// Lettere in ingresso (alfabeto ordinato).
    private var left: [Character]
    /// Lettere di uscita (scambi).
    private var right: [Character]

    public init() {
        self.left = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        self.right = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    }

    /// Configura una coppia di scambio (stringa di 2 caratteri, es. `"AB"`).
    /// Se i due caratteri coincidono la coppia viene ignorata (come nell'originale).
    public mutating func configure(_ pair: String) {
        let chars = Array(pair)
        guard chars.count == 2, chars[0] != chars[1] else { return }
        for i in 0..<26 {
            if left[i] == chars[0] { right[i] = chars[1] }
            if left[i] == chars[1] { right[i] = chars[0] }
        }
    }

    /// Scambia la lettera `x` secondo la configurazione corrente.
    public func swap(_ x: Character) -> Character {
        for i in 0..<26 where left[i] == x {
            return right[i]
        }
        return x
    }
}
