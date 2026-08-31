#!/usr/bin/env python3
"""
reference_enigma_m3.py — Implementazione di riferimento (Python) del motore
Enigma M3 FEDELE, identica alla libreria py-enigma (Brian Neal, MIT License).

Replica il comportamento REALE di una Enigma M3 (Wehrmacht):
  - rotori I–V con intaglio (turnover): I→Q, II→E, III→V, IV→J, V→Z
  - double stepping del rotore di mezzo
  - ring settings (Ringstellung)
  - riflettori B/C
  - plugboard (Steckerbrett)

Viene usata per generare i vettori di test del porting Swift (EnigmaCore) ed è
cross-validata contro py-enigma dal tool `validate_m3.py` (vedi Tools/).

NOTA: `reference_enigma.py` (nello stesso path) documenta invece la variante
ORIGINALE dell'app Android (2014/2015), senza intagli/ring settings: lì il
primo rotore dell'ordine scatta a ogni lettera e gli altri due restano fissi.

Convenzioni (identiche all'app SwiftUI):
  - `order`         : stringa con l'ordine dei rotori dal VELOCE al LENTO
                      (es. "123" -> Vect[0]=I veloce, Vect[2]=III lento).
  - `positions`     : posizioni iniziali 1..26 (1 = A, 26 = Z).
  - `ring_settings` : 1..26 (1 = A, nessun offset), una per rotore.
  - `reflector`     : "B" o "C".
  - `pairs`         : coppie della plugboard (es. ["AB", "CD"]).

Richiede SOLO la libreria standard.
"""

ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

WIRINGS = {
    "1": "EKMFLGDQVZNTOWYHXUSPAIBRCJ",
    "2": "AJDKSIRUXBLHWTMCQGZNPYFVOE",
    "3": "BDFHJLCPRTXVZNYEIWGAKMUSQO",
    "4": "ESOVPZJAYQUIRHXLNFTGKDCMWB",
    "5": "VZBRGITYUPSDNHLXAWMJQOFECK",
}

# Intagli (turnover) dei rotori I–V: la lettera mostrata nella finestrella in
# cui l'intaglio è allineato con la leva (pawl). Dati storici (Rijmenants).
NOTCHES = {
    "1": "Q",
    "2": "E",
    "3": "V",
    "4": "J",
    "5": "Z",
}

REFLECTORS = {
    "B": "YRUHQSLDPXNGOKMIEBFZCWVJAT",
    "C": "FVPJIAOYEDRZXWGCTKUQSBNMHL",
}


class RotorM3:
    """Rotore M3: cablaggio, intaglio, ring setting e posizione.

    Modello identico a py-enigma/rotor.py:
      - entry_map[pin]  = contatto (cablaggio da destra a sinistra)
      - exit_map[contact] = pin (inverso)
      - `pos` è la posizione interna sull'asse (0-25), `display` la lettera
        mostrata nella finestrella (0-25).
    """

    def __init__(self, name, ring_setting=0, position="A"):
        self.name = name
        self.ring_setting = ring_setting
        self.entry_map = [ord(c) - 65 for c in WIRINGS.get(name, ALPHABET)]
        self.exit_map = [0] * 26
        for i, v in enumerate(self.entry_map):
            self.exit_map[v] = i
        self.notches = {ord(c) - 65 for c in NOTCHES.get(name, "")}
        self.pos = 0
        self.display = 0
        self.set_display(position)

    def set_display(self, letter):
        if isinstance(letter, str):
            letter = ord(letter) - 65
        self.pos = (letter - self.ring_setting) % 26
        self.display = letter

    def signal_in(self, n):
        """Segnale che entra da destra (pin) -> esce a sinistra (contatto)."""
        pin = (n + self.pos) % 26
        contact = self.entry_map[pin]
        return (contact - self.pos) % 26

    def signal_out(self, n):
        """Segnale che entra da sinistra (contatto) -> esce a destra (pin)."""
        contact = (n + self.pos) % 26
        pin = self.exit_map[contact]
        return (pin - self.pos) % 26

    def notch_over_pawl(self):
        """True se l'intaglio è allineato con la leva (la lettera mostrata è
        quella dell'intaglio): al prossimo tasto farà avanzare il rotore a
        sinistra."""
        return self.display in self.notches

    def rotate(self):
        """Avanza di una posizione per azione meccanica."""
        self.pos = (self.pos + 1) % 26
        self.display = (self.pos + self.ring_setting) % 26


class ReflectorM3:
    """Riflettore M3: solo cablaggio (non ruota, nessun ring setting)."""

    def __init__(self, name):
        self.wiring = [ord(c) - 65 for c in REFLECTORS.get(name, ALPHABET)]
        self.exit_map = [0] * 26
        for i, v in enumerate(self.wiring):
            self.exit_map[v] = i

    def signal_in(self, n):
        return self.wiring[n]

    def signal_out(self, n):
        return self.exit_map[n]


class PlugboardM3:
    """Plugboard con mappa dei cablaggi (come py-enigma)."""

    def __init__(self, pairs=None):
        self.wiring_map = list(range(26))
        for pair in pairs or []:
            a, b = ord(pair[0]) - 65, ord(pair[1]) - 65
            self.wiring_map[a] = b
            self.wiring_map[b] = a

    def signal(self, n):
        return self.wiring_map[n]


def encrypt_m3(text, order, positions, reflector, pairs, ring_settings=None):
    """Cifra `text` con il comportamento reale di una Enigma M3.

    Stessa sequenza di py-enigma: prima lo stepping meccanico (intaglio +
    double stepping), poi il segnale elettrico attraverso plugboard, rotori
    (destra->sinistra), riflettore, rotori (sinistra->destra), plugboard.

    `order` è veloce->lento (come l'app); `positions` e `ring_settings` sono
    1..26 (1 = A).
    """
    if ring_settings is None:
        ring_settings = [1] * len(order)

    # rotori: veloce->lento (indice 0 = veloce). posizioni/ring 1..26 -> 0..25.
    rotors = []
    for name, pos, ring in zip(order, positions, ring_settings):
        r = RotorM3(name, ring_setting=(ring - 1) % 26)
        r.set_display((pos - 1) % 26)
        rotors.append(r)

    plug = PlugboardM3(pairs)
    rifl = ReflectorM3(reflector)

    out = []
    for ch in text.upper():
        if ch not in ALPHABET:
            continue
        signal = ord(ch) - 65

        # --- STEPPING MECCANICO (prima della cifratura) ---
        fast, middle, slow = rotors[0], rotors[1], rotors[2]
        rotate_middle = fast.notch_over_pawl() or middle.notch_over_pawl()
        rotate_slow = middle.notch_over_pawl()
        fast.rotate()
        if rotate_middle:
            middle.rotate()
        if rotate_slow:
            slow.rotate()

        # --- SEGNALE ELETTRICO ---
        pos = plug.signal(signal)
        for r in rotors:                # destra -> sinistra (veloce -> lento)
            pos = r.signal_in(pos)
        pos = rifl.signal_in(pos)       # riflettore
        for r in reversed(rotors):      # sinistra -> destra (lento -> veloce)
            pos = r.signal_out(pos)
        pos = plug.signal(pos)          # plugboard (uscita)

        out.append(chr(pos + 65))

    return "".join(out)


# ===========================================================================
# Casi di test (vettori)
# ===========================================================================

# (ordine, posizioni [1..26], ring [1..26], riflettore, coppie plugboard, testo)
TEST_CASES = [
    ("123", [1, 1, 1], [1, 1, 1], "B", [], "AAAAA"),
    ("123", [1, 1, 1], [1, 1, 1], "B", [], "HELLOWORLD"),
    ("123", [17, 5, 15], [1, 1, 1], "B", [], "HELLOWORLD"),
    ("321", [1, 1, 1], [1, 1, 1], "C", [], "ENIGMA"),
    ("135", [5, 12, 23], [1, 1, 1], "B", ["AB", "CD", "EF"], "ATTACKATDAWN"),
    ("254", [26, 1, 13], [2, 21, 12], "C", ["PZ", "QX", "RY"], "THEQUICKBROWNFOX"),
    ("123", [7, 14, 21], [1, 1, 1], "B", [], "A" * 30),
    ("543", [1, 2, 3], [1, 5, 26], "B", ["AZ"], "MESSAGGIOLUNGOQUESTO"),
]


def _fmt_pairs(pairs):
    return "[" + ", ".join(f'"{p}"' for p in pairs) + "]"


def main():
    print("# ============================================================")
    print("# Vettori M3 FEDELE (comportamento reale Enigma M3)")
    print("# Generati da reference_enigma_m3.py, cross-validati vs py-enigma")
    print("# ============================================================\n")
    for order, pos, ring, ref, pairs, text in TEST_CASES:
        cipher = encrypt_m3(text, order, pos, ref, pairs, ring)
        plain = encrypt_m3(cipher, order, pos, ref, pairs, ring)
        ok = plain.replace(" ", "") == text.replace(" ", "")
        print(f"order={order!r} positions={pos} rings={ring} ref={ref!r} pairs={_fmt_pairs(pairs)}")
        print(f"  plaintext = {text!r}")
        print(f"  cipher    = {cipher!r}")
        print(f"  roundtrip = {plain!r}  (reciproco: {ok})")
        assert ok, f"RECIPROCITA' FALLITA per {text}"
    print("\nTutti i vettori sono reciproci (cifrare 2 volte = originale).")


if __name__ == "__main__":
    main()
