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
// 1. Vettori noti — M3 FEDELE, generati da Tools/reference_enigma_m3.py
//    (cross-validati contro py-enigma da Tools/validate_m3.py)
// ---------------------------------------------------------------------------
print("Vettori noti (M3 fedele):")
let vectors: [(order: [Character], positions: [Int], rings: [Int], reflector: Character, pairs: [String], plaintext: String, cipher: String)] = [
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

for v in vectors {
    let machine = EnigmaMachine(
        rotorOrder: v.order,
        positions: v.positions,
        ringSettings: v.rings,
        reflectorName: v.reflector,
        plugboardPairs: v.pairs
    )
    let output = machine.encrypt(v.plaintext)
    check(
        output == v.cipher,
        "order=\(v.order) pos=\(v.positions) rings=\(v.rings) ref=\(v.reflector) pairs=\(v.pairs): \(v.plaintext) -> \(output)"
    )
}

// ---------------------------------------------------------------------------
// 2. Reciprocità (cifrare due volte = originale)
// ---------------------------------------------------------------------------
print("Reciprocità:")
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
        let twice = machine.encrypt(machine.encrypt(text))
        check(twice == text, "reciproco per '\(text)' con ord=\(config.rotorOrder)")
    }
}

// ---------------------------------------------------------------------------
// 3. Stepping fedele (intaglio / turnover)
// ---------------------------------------------------------------------------
print("Stepping fedele:")
do {
    var machine = EnigmaMachine(rotorOrder: ["1", "2", "3"], positions: [1, 1, 1], reflectorName: "B", plugboardPairs: [])
    for _ in 0..<17 { _ = machine.keyPress("A") }
    check(machine.display == ["R", "B", "A"], "dopo 17 tasti: rotore di mezzo avanza (intaglio Q)")
    for _ in 0..<26 { _ = machine.keyPress("A") }
    check(machine.display == ["R", "C", "A"], "dopo 43 tasti: rotore di mezzo avanza di nuovo")
}

// ---------------------------------------------------------------------------
// 4. Gestione dell'input
// ---------------------------------------------------------------------------
print("Gestione input:")
do {
    let machine = EnigmaMachine()
    check(machine.encrypt("Hello World!") == machine.encrypt("HELLOWORLD"), "spazi/punteggiatura ignorati e maiuscole")
    check(machine.encrypt("aaaaa") == machine.encrypt("AAAAA"), "minuscole normalizzate")
    check(machine.encrypt("1234 -!?") == "", "caratteri non alfabetici -> stringa vuota")
    let first = machine.encrypt("AAAAA")
    let second = machine.encrypt("AAAAA")
    check(first == second && first == "FTZMG", "ogni chiamata riparte dalle stesse impostazioni")
}

// ---------------------------------------------------------------------------
print()
if failures == 0 {
    print("Tutti i controlli superati ✅")
} else {
    print("\(failures) controllo/i fallito/i ❌")
    exit(1)
}
