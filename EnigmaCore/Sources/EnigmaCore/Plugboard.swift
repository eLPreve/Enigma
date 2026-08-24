import Foundation

/// Pannello a prese multiple (Steckerbrett) della macchina Enigma.
///
/// Ogni cavo collega due prese: scambia la lettera in ingresso con quella
/// collegata e viceversa (percorso di andata e ritorno). Modello identico a
/// py-enigma: una mappa `wiringMap[n]` con gli indici 0-25.
public struct Plugboard {
    /// Mappa dei cablaggi: `wiringMap[n]` è la lettera (0-25) con cui `n` viene scambiata.
    private var wiringMap: [Int]

    public init() {
        self.wiringMap = Array(0..<26)
    }

    /// Configura una coppia di scambio (stringa di 2 caratteri, es. `"AB"`).
    /// Se i due caratteri coincidono la coppia viene ignorata.
    public mutating func configure(_ pair: String) {
        let chars = Array(pair)
        guard chars.count == 2, chars[0] != chars[1] else { return }
        let a = Int(chars[0].asciiValue!) - 65
        let b = Int(chars[1].asciiValue!) - 65
        wiringMap[a] = b
        wiringMap[b] = a
    }

    /// Scambia il segnale (indice 0-25) secondo la configurazione corrente.
    public func signal(_ n: Int) -> Int {
        wiringMap[n]
    }
}
