import Foundation
import EnigmaCore

// Runner di verifica del motore EnigmaCore.
//
// Esegue le stesse verifiche della suite XCTest (Tests/EnigmaCoreTests),
// ma senza richiedere Xcode completo: su macchine con il solo Command Line
// Tools il modulo XCTest non è disponibile, quindi usiamo assert manuali.
//
// Uso:  swift run EnigmaCLI

var failures = 0

func check(_ condition: Bool, _ message: String) {
    if condition {
        print("  PASS  \(message)")
    } else {
        print("  FAIL  \(message)")
        failures += 1
    }
}

// ---------------------------------------------------------------------------
// 1. Vettori noti — generati indipendentemente da Tools/reference_enigma.py
// ---------------------------------------------------------------------------
print("Vettori noti:")
let vectors: [(order: [Character], positions: [Int], reflector: Character, pairs: [String], plaintext: String, cipher: String)] = [
    (["1", "2", "3"], [1, 1, 1], "B", [], "AAAAA", "NEVRD"),
    (["1", "2", "3"], [1, 1, 1], "B", [], "HELLOWORLD", "EAYHMAXSNN"),
    (["3", "2", "1"], [1, 1, 1], "C", [], "ENIGMA", "QVRYAP"),
    (["1", "3", "5"], [5, 12, 23], "B", ["AB", "CD", "EF"], "ATTACKATDAWN", "SVJVNBLEUTPT"),
    (["2", "5", "4"], [26, 1, 13], "C", ["PZ", "QX", "RY"], "THEQUICKBROWNFOX", "XLDRYQGSPALRFJPY"),
    (["1", "2", "3"], [7, 14, 21], "B", [], "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", "DXJXEEKNWWCRYCJYQFBZNEVRDWDXJX"),
    (["5", "4", "3"], [1, 2, 3], "B", ["AZ"], "MESSAGGIOLUNGOQUESTO", "TWXOYRNXDQFAXNBDJBEN"),
]

for v in vectors {
    let machine = EnigmaMachine(
        rotorOrder: v.order,
        positions: v.positions,
        reflectorName: v.reflector,
        plugboardPairs: v.pairs
    )
    let output = machine.encrypt(v.plaintext)
    check(
        output == v.cipher,
        "order=\(v.order) pos=\(v.positions) ref=\(v.reflector) pairs=\(v.pairs): \(v.plaintext) -> \(output)"
    )
}

// ---------------------------------------------------------------------------
// 2. Reciprocità (cifrare due volte = originale)
// ---------------------------------------------------------------------------
print("Reciprocità:")
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
        let twice = machine.encrypt(machine.encrypt(text))
        check(twice == text, "reciproco per '\(text)' con ord=\(config.rotorOrder)")
    }
}

// ---------------------------------------------------------------------------
// 3. Gestione dell'input
// ---------------------------------------------------------------------------
print("Gestione input:")
do {
    let machine = EnigmaMachine()
    check(machine.encrypt("Hello World!") == machine.encrypt("HELLOWORLD"), "spazi/punteggiatura ignorati e maiuscole")
    check(machine.encrypt("aaaaa") == machine.encrypt("AAAAA"), "minuscole normalizzate")
    check(machine.encrypt("1234 -!?") == "", "caratteri non alfabetici -> stringa vuota")
    let first = machine.encrypt("AAAAA")
    let second = machine.encrypt("AAAAA")
    check(first == second && first == "NEVRD", "ogni chiamata riparte dalle stesse impostazioni")
}

// ---------------------------------------------------------------------------
print()
if failures == 0 {
    print("Tutti i controlli superati ✅")
} else {
    print("\(failures) controllo/i fallito/i ❌")
    exit(1)
}
