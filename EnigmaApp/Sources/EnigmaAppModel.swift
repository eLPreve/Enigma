import Foundation
import Observation
import EnigmaCore

/// Una coppia del pannello a prese (plugboard): due lettere collegate da un cavo.
/// Se le due lettere coincidono, la coppia non effettua alcuno scambio.
struct PlugPair: Identifiable, Equatable {
    let id = UUID()
    var first: String = "A"
    var second: String = "A"
}

/// Stato condiviso dell'app: testo da cifrare e configurazione della macchina.
///
/// Porting delle schermate dell'app Android originale (MainActivity,
/// Rotor_Settings, Switcher_Settings, Reflector_Settings), ma con un unico
/// punto di verità invece dello stato passato tra Activity via Intent.
@Observable
final class EnigmaAppModel {
    // MARK: - Testo

    var plaintext = ""
    var ciphertext = ""

    // MARK: - Configurazione macchina

    /// Ordine dei rotori, dal veloce al lento. Valori "1"…"5" (rotori I…V).
    var rotorOrder: [String] = ["1", "2", "3"]
    /// Posizioni iniziali dei rotori (1 = A … 26 = Z).
    var positions: [Int] = [1, 1, 1]
    /// Riflettore: "B" o "C".
    var reflector: String = "B"
    /// Le 10 coppie del pannello a prese.
    var plugboard: [PlugPair] = (0..<10).map { _ in PlugPair() }

    // MARK: - Configurazione per il motore

    var configuration: EnigmaConfiguration {
        EnigmaConfiguration(
            rotorOrder: rotorOrder.map { Character($0) },
            positions: positions,
            reflector: Character(reflector),
            plugboardPairs: plugboard.map { $0.first + $0.second }
        )
    }

    // MARK: - Azioni

    /// Cifra il testo in chiaro con la configurazione corrente.
    /// Enigma è simmetrica: con le stesse impostazioni, cifrare due volte
    /// restituisce l'originale (quindi questo metodo decifra anche).
    func encrypt() {
        let machine = EnigmaMachine(configuration: configuration)
        ciphertext = machine.encrypt(plaintext)
    }

    func clear() {
        plaintext = ""
        ciphertext = ""
    }
}
