import XCTest
@testable import EnigmaCore

final class EnigmaMachineTests: XCTestCase {

    // MARK: - Vettori di test
    // Generati da Tools/reference_enigma_m3.py (referenza M3 fedele, cross-validata
    // contro la libreria py-enigma da Tools/validate_m3.py).

    func testKnownVectors() {
        let cases: [(order: [Character], positions: [Int], rings: [Int], reflector: Character, pairs: [String], plaintext: String, cipher: String)] = [
            (["1", "2", "3"], [1, 1, 1], [1, 1, 1], "B", [], "AAAAA", "FTZMG"),
            (["1", "2", "3"], [1, 1, 1], [1, 1, 1], "B", [], "HELLOWORLD", "MFNCZBBFZM"),
            (["1", "2", "3"], [17, 5, 15], [1, 1, 1], "B", [], "HELLOWORLD", "BCEFCYZHER"),
            (["3", "2", "1"], [1, 1, 1], [1, 1, 1], "C", [], "ENIGMA", "UCTZFQ"),
            (["1", "3", "5"], [5, 12, 23], [1, 1, 1], "B", ["AB", "CD", "EF"], "ATTACKATDAWN", "WSBMGHFQXCLA"),
            (["2", "5", "4"], [26, 1, 13], [2, 21, 12], "C", ["PZ", "QX", "RY"], "THEQUICKBROWNFOX", "SYIRYRNBOOSHKQUP"),
            (["1", "2", "3"], [7, 14, 21], [1, 1, 1], "B", [], String(repeating: "A", count: 30), "LOLNFVBFXVZXZWYVEHIVXJFDHLOQRX"),
            (["5", "4", "3"], [1, 2, 3], [1, 5, 26], "B", ["AZ"], "MESSAGGIOLUNGOQUESTO", "UOEJZVLCAGLAPUCTXXBH"),
            (["1", "2", "3"], [1, 1, 1], [1, 1, 1], "B", [], String(repeating: "A", count: 60), "FTZMGISXIPJWGDNJJCOQTYRIGDMXFIESRWZGTOIUIEKKDCSHTPYOEPVXNHVR"),
            (["1", "2", "3"], [1, 1, 1], [1, 1, 1], "B", [], "THEQUICKBROWNFOXJUMPSOVERTHELAZYDOG", "ZPTRRATEUJDAWKFEABUUYIIPLXXLZIJVNEH"),
            (["5", "4", "3"], [1, 2, 3], [13, 7, 20], "C", ["AZ", "BY", "CX"], "TESTAVECTORIPERSISTENZA", "QAJHOJYXLHKVBTQELPVUUUD"),
            (["2", "1", "4"], [12, 20, 3], [1, 1, 1], "B", [], String(repeating: "A", count: 80), "DZBLRMFDQUTNHYZZFOLILPSMCGQKVETKNCWGEGYOKKWKHZKWIIPTWWFPLBGOXKXPCDNPKPZZLWHUFGQQ"),
            (["3", "5", "1"], [10, 10, 10], [1, 1, 1], "C", ["QW", "ER", "TY"], "NOTCHEDDUBLESTEPPING", "SCSWAWJXNUFWKCVGKGOC"),
        ]

        for c in cases {
            let machine = EnigmaMachine(
                rotorOrder: c.order,
                positions: c.positions,
                ringSettings: c.rings,
                reflectorName: c.reflector,
                plugboardPairs: c.pairs
            )
            XCTAssertEqual(
                machine.encrypt(c.plaintext),
                c.cipher,
                "Vettore fallito: order=\(c.order) pos=\(c.positions) rings=\(c.rings) ref=\(c.reflector) pairs=\(c.pairs)"
            )
        }
    }

    // MARK: - Reciprocità (Enigma è simmetrica: cifrare due volte = originale)

    func testReciprocity() {
        let configs: [EnigmaConfiguration] = [
            EnigmaConfiguration(),
            EnigmaConfiguration(rotorOrder: ["3", "2", "1"], positions: [7, 20, 3], ringSettings: [1, 13, 7], reflector: "C", plugboardPairs: ["AZ", "BY", "CX"]),
            EnigmaConfiguration(rotorOrder: ["5", "1", "4"], positions: [26, 15, 2], ringSettings: [4, 4, 4], reflector: "C", plugboardPairs: []),
            EnigmaConfiguration(rotorOrder: ["2", "3", "5"], positions: [13, 8, 24], ringSettings: [25, 2, 11], reflector: "B", plugboardPairs: ["QW", "ER"]),
        ]
        let texts = ["HELLO", "ATTACKATDAWN", "MESSAGGIO", "ZYXWVUTSRQPONMLKJIHGFEDCBA"]

        for config in configs {
            let machine = EnigmaMachine(configuration: config)
            for text in texts {
                let once = machine.encrypt(text)
                let twice = machine.encrypt(once)
                XCTAssertEqual(twice, text, "Reciprocità fallita per \(text) con config \(config)")
            }
        }
    }

    // MARK: - Ring settings

    func testRingSettingsChangeCiphertext() {
        let base = EnigmaMachine(rotorOrder: ["1", "2", "3"], positions: [1, 1, 1], reflectorName: "B", plugboardPairs: [])
        let ringed = EnigmaMachine(rotorOrder: ["1", "2", "3"], positions: [1, 1, 1], ringSettings: [5, 5, 5], reflectorName: "B", plugboardPairs: [])
        XCTAssertNotEqual(base.encrypt("HELLOWORLD"), ringed.encrypt("HELLOWORLD"))
        // Anche con i ring settings Enigma resta simmetrica.
        XCTAssertEqual(ringed.encrypt(ringed.encrypt("HELLOWORLD")), "HELLOWORLD")
    }

    // MARK: - Stepping fedele (intaglio / turnover)

    func testRotorsTurnOver() {
        var machine = EnigmaMachine(
            rotorOrder: ["1", "2", "3"],
            positions: [1, 1, 1],
            reflectorName: "B",
            plugboardPairs: []
        )
        // Il rotore veloce (I) ha l'intaglio a Q: dopo 17 pressioni (Q → R)
        // il rotore di mezzo avanza una volta.
        for _ in 0..<17 {
            _ = machine.keyPress("A")
        }
        XCTAssertEqual(machine.display, ["R", "B", "A"])

        // Dopo altri 26 tasti (totale 43) l'intaglio Q viene raggiunto di nuovo
        // e il rotore di mezzo avanza di nuovo.
        for _ in 0..<26 {
            _ = machine.keyPress("A")
        }
        XCTAssertEqual(machine.display, ["R", "C", "A"])
    }

    // MARK: - Comportamento dell'input

    func testIgnoresNonAlphabeticAndUppercases() {
        let machine = EnigmaMachine()
        // Spazi e punteggiatura ignorati, lettere convertite in maiuscolo
        XCTAssertEqual(machine.encrypt("Hello World!"), machine.encrypt("HELLOWORLD"))
        XCTAssertEqual(machine.encrypt("aaaaa"), machine.encrypt("AAAAA"))
        XCTAssertEqual(machine.encrypt("1234 -!?"), "")
    }

    func testEachCallRestartsFromSameSettings() {
        let machine = EnigmaMachine()
        let first = machine.encrypt("AAAAA")
        let second = machine.encrypt("AAAAA")
        XCTAssertEqual(first, second, "Ogni chiamata deve ripartire dalle stesse impostazioni")
        XCTAssertEqual(first, "FTZMG")
    }
}
