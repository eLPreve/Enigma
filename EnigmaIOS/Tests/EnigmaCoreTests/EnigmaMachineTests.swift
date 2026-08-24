import XCTest
@testable import EnigmaCore

final class EnigmaMachineTests: XCTestCase {

    // MARK: - Vettori di test
    // Generati in modo indipendente da Tools/reference_enigma.py (referenza Python
    // che replica esattamente l'algoritmo dell'app Android originale).

    func testKnownVectors() {
        let cases: [(order: [Character], positions: [Int], reflector: Character, pairs: [String], plaintext: String, cipher: String)] = [
            (["1", "2", "3"], [1, 1, 1], "B", [], "AAAAA", "NEVRD"),
            (["1", "2", "3"], [1, 1, 1], "B", [], "HELLOWORLD", "EAYHMAXSNN"),
            (["3", "2", "1"], [1, 1, 1], "C", [], "ENIGMA", "QVRYAP"),
            (["1", "3", "5"], [5, 12, 23], "B", ["AB", "CD", "EF"], "ATTACKATDAWN", "SVJVNBLEUTPT"),
            (["2", "5", "4"], [26, 1, 13], "C", ["PZ", "QX", "RY"], "THEQUICKBROWNFOX", "XLDRYQGSPALRFJPY"),
            (["1", "2", "3"], [7, 14, 21], "B", [], "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", "DXJXEEKNWWCRYCJYQFBZNEVRDWDXJX"),
            (["5", "4", "3"], [1, 2, 3], "B", ["AZ"], "MESSAGGIOLUNGOQUESTO", "TWXOYRNXDQFAXNBDJBEN"),
        ]

        for c in cases {
            let machine = EnigmaMachine(
                rotorOrder: c.order,
                positions: c.positions,
                reflectorName: c.reflector,
                plugboardPairs: c.pairs
            )
            XCTAssertEqual(
                machine.encrypt(c.plaintext),
                c.cipher,
                "Vettore fallito: order=\(c.order) pos=\(c.positions) ref=\(c.reflector) pairs=\(c.pairs)"
            )
        }
    }

    // MARK: - Reciprocità (Enigma è simmetrica: cifrare due volte = originale)

    func testReciprocity() {
        let configs: [EnigmaConfiguration] = [
            EnigmaConfiguration(),
            EnigmaConfiguration(rotorOrder: ["3", "2", "1"], positions: [7, 20, 3], reflector: "C", plugboardPairs: ["AZ", "BY", "CX"]),
            EnigmaConfiguration(rotorOrder: ["5", "1", "4"], positions: [26, 15, 2], reflector: "C", plugboardPairs: []),
            EnigmaConfiguration(rotorOrder: ["2", "3", "5"], positions: [13, 8, 24], reflector: "B", plugboardPairs: ["QW", "ER"]),
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
        XCTAssertEqual(first, "NEVRD")
    }
}
