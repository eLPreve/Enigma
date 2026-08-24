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

/// Stato condiviso dell'app: testo, configurazione (persistita) e "macchina
/// reale" che si aggiorna mentre digiti.
///
/// La macchina viene ricreata da `configuration` a ogni aggiornamento e
/// riprodotta sul testo in chiaro corrente: le finestrelle dei rotori e la
/// lampboard riflettono lo stato reale dell'M3 dopo ogni tasto.
@Observable
final class EnigmaAppModel {
    // MARK: - Testo

    var plaintext = ""
    private(set) var ciphertext = ""

    // MARK: - Configurazione macchina (persistita in UserDefaults)

    /// Ordine dei rotori, dal veloce al lento. Valori "1"…"5" (rotori I…V).
    var rotorOrder: [String] = ["1", "2", "3"]
    /// Posizioni iniziali dei rotori (1 = A … 26 = Z).
    var positions: [Int] = [1, 1, 1]
    /// Ring settings (Ringstellung) dei rotori (1 = A, nessun offset).
    var ringSettings: [Int] = [1, 1, 1]
    /// Riflettore: "B" o "C".
    var reflector: String = "B"
    /// Le 10 coppie del pannello a prese.
    var plugboard: [PlugPair] = (0..<10).map { _ in PlugPair() }
    /// Raggruppa il testo cifrato in blocchi da 5 (come i messaggi reali).
    var groupInFives = false

    // MARK: - Stato "macchina reale"

    /// Ultima lampadina accesa (lettera cifrata dell'ultimo tasto premuto).
    private(set) var activeLamp: Character?

    /// La macchina "fisica" corrente: il suo stato (finestrelle) è esposto da
    /// `rotorDisplay` e riflette il testo in chiaro già battuto.
    private(set) var machine = EnigmaMachine()

    /// Lettere mostrate nelle finestrelle dei rotori (veloce → lento).
    var rotorDisplay: [Character] { machine.display }

    // MARK: - Configurazione per il motore

    var configuration: EnigmaConfiguration {
        EnigmaConfiguration(
            rotorOrder: rotorOrder.map { Character($0) },
            positions: positions,
            ringSettings: ringSettings,
            reflector: Character(reflector),
            plugboardPairs: plugboard.map { $0.first + $0.second }
        )
    }

    /// Testo cifrato formattato: in blocchi da 5 se `groupInFives` è attivo.
    var formattedCiphertext: String {
        guard groupInFives, !ciphertext.isEmpty else { return ciphertext }
        return stride(from: 0, to: ciphertext.count, by: 5).map { start in
            let from = ciphertext.index(ciphertext.startIndex, offsetBy: start)
            let to = ciphertext.index(from, offsetBy: min(5, ciphertext.count - start))
            return String(ciphertext[from..<to])
        }.joined(separator: " ")
    }

    /// Avvisi di configurazione non valida (lettere duplicate nella plugboard,
    /// rotori selezionati più volte). Vuoto se la configurazione è valida.
    var validationWarnings: [String] {
        var warnings: [String] = []

        // Lettere usate in più coppie della plugboard
        var used = Set<Character>()
        for pair in activePlugPairs {
            for ch in [pair.first.first!, pair.second.first!] {
                if !used.insert(ch).inserted {
                    warnings.append(String(localized: "Lettera \(ch) usata in più cavi della plugboard"))
                }
            }
        }

        // Rotori duplicati nell'ordine
        var seen = Set<String>()
        for r in rotorOrder {
            if !seen.insert(r).inserted {
                warnings.append(String(localized: "Rotore \(Self.roman(r)) selezionato più volte"))
            }
        }

        return warnings
    }

    init() {
        restoreSettings()
    }

    // MARK: - Azioni

    /// Premuta una lettera (tastiera/lampboard): la aggiunge al testo in
    /// chiaro e aggiorna la macchina.
    func press(_ letter: Character) {
        let upper = Character(String(letter).uppercased())
        guard upper.isLetter, upper.isASCII else { return }
        plaintext.append(upper)
        updateLive()
    }

    /// Ricalcola il testo cifrato e lo stato della macchina a partire dal
    /// testo in chiaro corrente e dalla configurazione. Enigma è simmetrica:
    /// con le stesse impostazioni, cifrare due volte restituisce l'originale
    /// (quindi questo metodo gestisce anche la decifratura).
    func updateLive() {
        var m = EnigmaMachine(configuration: configuration)
        var out = ""
        var last: Character?
        for ch in plaintext.uppercased() where ch.isLetter && ch.isASCII {
            last = m.keyPress(ch)
            out.append(last!)
        }
        ciphertext = out
        activeLamp = last
        machine = m
    }

    /// Porta il testo cifrato nel campo in chiaro e azzera la macchina
    /// (per decifrare un messaggio: incolla il cifrato e premi questo pulsante).
    func swapToPlaintext() {
        plaintext = ciphertext
        updateLive()
    }

    func clear() {
        plaintext = ""
        ciphertext = ""
        activeLamp = nil
        machine = EnigmaMachine(configuration: configuration)
    }

    // MARK: - Messaggi salvati (SwiftData)

    /// Crea un record con il messaggio e la configurazione correnti.
    func makeRecord() -> MessageRecord {
        MessageRecord(
            plaintext: plaintext,
            ciphertext: ciphertext,
            rotorOrder: rotorOrder.joined(separator: ","),
            positions: positions.map(String.init).joined(separator: ","),
            ringSettings: ringSettings.map(String.init).joined(separator: ","),
            reflector: reflector,
            plugboard: activePlugPairs.map { $0.first + $0.second }.joined(separator: " ")
        )
    }

    /// Applica un record salvato: configurazione e testo tornano nella macchina.
    func apply(_ record: MessageRecord) {
        plaintext = record.plaintext
        let order = record.rotorOrder.split(separator: ",").map(String.init)
        if order.count == 3 { rotorOrder = order }
        let pos = record.positions.split(separator: ",").compactMap { Int($0) }
        if pos.count == 3 { positions = pos }
        let rings = record.ringSettings.split(separator: ",").compactMap { Int($0) }
        if rings.count == 3 { ringSettings = rings }
        if record.reflector == "B" || record.reflector == "C" { reflector = record.reflector }
        var board = (0..<10).map { _ in PlugPair() }
        let pairs = record.plugboard.split(separator: " ").map(String.init)
        for (i, p) in pairs.prefix(10).enumerated() {
            let chars = Array(p)
            if chars.count == 2 {
                board[i] = PlugPair(first: String(chars[0]), second: String(chars[1]))
            }
        }
        plugboard = board
        updateLive()
        persistSettings()
    }

    // MARK: - Persistenza della configurazione (UserDefaults)

    private struct SavedConfiguration: Codable {
        var rotorOrder: [String]
        var positions: [Int]
        var ringSettings: [Int]
        var reflector: String
        var plugboard: [String]
        var groupInFives: Bool
    }

    private static let settingsKey = "enigma.savedConfiguration"

    private var activePlugPairs: [PlugPair] {
        plugboard.filter { $0.first != $0.second }
    }

    private static func roman(_ s: String) -> String {
        ["1": "I", "2": "II", "3": "III", "4": "IV", "5": "V"][s] ?? s
    }

    /// Salva la configurazione corrente in UserDefaults.
    /// Chiamato dalle schermate alla chiusura (onDisappear) e dopo `apply(_:)`.
    func persistSettings() {
        let saved = SavedConfiguration(
            rotorOrder: rotorOrder,
            positions: positions,
            ringSettings: ringSettings,
            reflector: reflector,
            plugboard: activePlugPairs.map { $0.first + $0.second },
            groupInFives: groupInFives
        )
        if let data = try? JSONEncoder().encode(saved) {
            UserDefaults.standard.set(data, forKey: Self.settingsKey)
        }
    }

    private func restoreSettings() {
        guard
            let data = UserDefaults.standard.data(forKey: Self.settingsKey),
            let saved = try? JSONDecoder().decode(SavedConfiguration.self, from: data)
        else { return }
        if saved.rotorOrder.count == 3 { rotorOrder = saved.rotorOrder }
        if saved.positions.count == 3 { positions = saved.positions }
        if saved.ringSettings.count == 3 { ringSettings = saved.ringSettings }
        if saved.reflector == "B" || saved.reflector == "C" { reflector = saved.reflector }
        var board = (0..<10).map { _ in PlugPair() }
        for (i, p) in saved.plugboard.prefix(10).enumerated() {
            let chars = Array(p)
            if chars.count == 2 {
                board[i] = PlugPair(first: String(chars[0]), second: String(chars[1]))
            }
        }
        plugboard = board
        groupInFives = saved.groupInFives
    }
}
