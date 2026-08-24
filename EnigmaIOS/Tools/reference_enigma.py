#!/usr/bin/env python3
"""
reference_enigma.py — Implementazione di riferimento (Python) del motore Enigma
così come era nell'app Android originale (Java).

Serve a generare vettori di test indipendenti per validare il porting Swift
(EnigmaCore). Replica ESATTAMENTE il comportamento di MainActivity.java /
Rotore.java / Plugboard.java / Reflector.java:

  - il primo rotore dell'ordine (Vect[0]) è quello "veloce" e scatta dopo ogni lettera;
  - l'ordine dei rotori è quello della stringa (es. "123" -> Vect[0]=I, Vect[1]=II, Vect[2]=III);
  - il "rotore statico" è una mappa identità usata per ingresso/uscita per indice;
  - posizioni 1..26, riflettore 'B' o 'C', plugboard a coppie.

NOTA: NESSUN miglioramento di fedeltà storica (notch, double stepping, ring
settings): questi verranno aggiunti in seguito.
"""

WIRINGS = {
    "1": "EKMFLGDQVZNTOWYHXUSPAIBRCJ",
    "2": "AJDKSIRUXBLHWTMCQGZNPYFVOE",
    "3": "BDFHJLCPRTXVZNYEIWGAKMUSQO",
    "4": "ESOVPZJAYQUIRHXLNFTGKDCMWB",
    "5": "VZBRGITYUPSDNHLXAWMJQOFECK",
}

REFLECTORS = {
    "B": "YRUHQSLDPXNGOKMIEBFZCWVJAT",
    "C": "FVPJIAOYEDRZXWGCTKUQSBNMHL",
}

ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"


class Rotor:
    def __init__(self, name):
        self.name = name
        self.R = list(ALPHABET)   # faccia destra (identity se non ruotato)
        self.L = list(ALPHABET)   # faccia sinistra (cablaggio)
        if name in WIRINGS:
            self.L = list(WIRINGS[name])
        else:
            # rotore statico: R azzerato, L resta identity
            self.R = ["0"] * 26

    def step(self):
        """Ruota a sinistra di una posizione entrambe le facce."""
        self.R = self.R[1:] + [self.R[0]]
        self.L = self.L[1:] + [self.L[0]]

    def contact(self, x, flag):
        """flag=True -> cerca su R; flag=False -> cerca su L."""
        arr = self.R if flag else self.L
        return arr.index(x)

    def letter(self, index, side):
        return self.R[index] if side == "R" else self.L[index]


class Reflector:
    def __init__(self, name):
        self.name = name
        self.R = list(ALPHABET)
        self.L = list(REFLECTORS.get(name, ["0"] * 26))

    def contact(self, x, flag):
        arr = self.R if flag else self.L
        return arr.index(x)

    def letter(self, index, side):
        return self.R[index] if side == "R" else self.L[index]


class Plugboard:
    def __init__(self):
        self.D = list(ALPHABET)
        self.S = list(ALPHABET)

    def configure(self, pair):
        a, b = pair[0], pair[1]
        for i in range(26):
            if self.D[i] == a:
                self.S[i] = b
            if self.D[i] == b:
                self.S[i] = a

    def swap(self, x):
        for i in range(26):
            if x == self.D[i]:
                return self.S[i]
        return x


def encrypt(text, order, positions, reflector, pairs):
    """Cifra `text` con la stessa logica dell'app Android originale."""
    plug = Plugboard()
    for pair in pairs:
        if pair[0] != pair[1]:
            plug.configure(pair)

    rotors = [Rotor(c) for c in order]

    # impostazione posizioni iniziali
    for i in range(len(rotors)):
        target = chr(positions[i] + 64)
        for _ in range(26):
            if rotors[i].letter(0, "R") == target:
                pass
            else:
                rotors[i].step()

    rifl = Reflector(reflector)

    out = []
    for ch in text.upper():
        if ch not in ALPHABET:
            continue
        letter = ch

        # PLUGBOARD (andata)
        letter = plug.swap(letter)

        # ROTORE STATICO (identity) -> indice; ingresso nel primo rotore per indice
        entry_index = ALPHABET.index(letter)
        letter = rotors[0].letter(entry_index, "R")

        # ROTORI (andata): destra -> sinistra
        for j in range(len(rotors)):
            idx = rotors[j].contact(letter, True)
            letter = rotors[j].letter(idx, "L")

        # RIFLETTORE
        idx = rifl.contact(letter, True)
        letter = rifl.letter(idx, "L")

        # ROTORI (ritorno): sinistra -> destra
        for j in range(len(rotors) - 1, -1, -1):
            idx = rotors[j].contact(letter, False)
            letter = rotors[j].letter(idx, "R")

        # ROTORE STATICO (uscita): indice sul primo rotore -> lettera identity
        exit_index = rotors[0].contact(letter, True)
        letter = ALPHABET[exit_index]

        # PLUGBOARD (ritorno)
        letter = plug.swap(letter)

        out.append(letter)

        # MOVIMENTO PERIODICO: scatta il primo rotore
        rotors[0].step()

    return "".join(out)


# ---------------------------------------------------------------------------
# Casi di test (vettori) — generati in modo deterministico
# ---------------------------------------------------------------------------
TEST_CASES = [
    # (ordine rotori, posizioni [1..26], riflettore, coppie plugboard, testo in chiaro)
    ("123", [1, 1, 1], "B", [], "AAAAA"),
    ("123", [1, 1, 1], "B", [], "HELLOWORLD"),
    ("321", [1, 1, 1], "C", [], "ENIGMA"),
    ("135", [5, 12, 23], "B", ["AB", "CD", "EF"], "ATTACKATDAWN"),
    ("254", [26, 1, 13], "C", ["PZ", "QX", "RY"], "THEQUICKBROWNFOX"),
    ("12345"[0:3], [7, 14, 21], "B", [], "A" * 30),
    ("543", [1, 2, 3], "B", ["AZ"], "MESSAGGIOLUNGOQUESTO"),
]


def main():
    print("# Vettori di test generati da reference_enigma.py")
    for order, pos, ref, pairs, text in TEST_CASES:
        cipher = encrypt(text, order, pos, ref, pairs)
        plain = encrypt(cipher, order, pos, ref, pairs)
        ok = plain.replace(" ", "") == text.replace(" ", "")
        print(f"order={order} pos={pos} ref={ref} pairs={pairs}")
        print(f"  plaintext = {text!r}")
        print(f"  cipher    = {cipher!r}")
        print(f"  roundtrip = {plain!r}  (reciproco: {ok})")
        assert ok, f"RECIPROCITA' FALLITA per {text}"
    print("\nTutti i vettori sono reciproci (cifrare 2 volte = originale).")


if __name__ == "__main__":
    main()
