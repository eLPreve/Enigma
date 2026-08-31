import Foundation
import SwiftData

/// Messaggio salvato: testo in chiaro/cifrato e configurazione della macchina.
///
/// Porting della tabella `Texts` del database SQLite dell'app Android originale
/// (`MyDatabase`/`Record`): ordine rotori, posizioni, anelli, riflettore e cavi
/// della plugboard sono salvati come stringhe delimitate.
@Model
final class MessageRecord {
    @Attribute(.unique) var id: UUID
    /// Testo in chiaro.
    var plaintext: String
    /// Testo cifrato.
    var ciphertext: String
    /// Ordine rotori, es. "1,2,3".
    var rotorOrder: String
    /// Posizioni iniziali, es. "1,1,1".
    var positions: String
    /// Ring settings, es. "1,1,1".
    var ringSettings: String
    /// Riflettore: "B" o "C".
    var reflector: String
    /// Coppie plugboard, es. "AB CD EF".
    var plugboard: String
    /// Data di salvataggio.
    var date: Date

    init(
        plaintext: String,
        ciphertext: String,
        rotorOrder: String,
        positions: String,
        ringSettings: String,
        reflector: String,
        plugboard: String,
        date: Date = .now
    ) {
        self.id = UUID()
        self.plaintext = plaintext
        self.ciphertext = ciphertext
        self.rotorOrder = rotorOrder
        self.positions = positions
        self.ringSettings = ringSettings
        self.reflector = reflector
        self.plugboard = plugboard
        self.date = date
    }
}
