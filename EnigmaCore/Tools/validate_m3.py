#!/usr/bin/env python3
"""
validate_m3.py — Cross-validazione della referenza M3 contro py-enigma.

Confronta `reference_enigma_m3.encrypt_m3` con la libreria di riferimento
py-enigma (Brian Neal) su:
  1. i vettori noti di TEST_CASES;
  2. configurazioni casuali (fuzz) generate deterministicamente.

Uso (dal venv di Tools/):
    .venv/bin/python EnigmaCore/Tools/validate_m3.py [--fuzz N]

Richiede `py-enigma` (pip install py-enigma). NOTA: la libreria è una dipendenza
SOLO di sviluppo per validare il motore; il motore Swift non ne dipende.
"""

import argparse
import random
import string
import sys
from os.path import dirname, join, abspath

# aggiunge Tools/ al path per importare reference_enigma_m3
TOOLS = dirname(abspath(__file__))
sys.path.insert(0, TOOLS)

from reference_enigma_m3 import encrypt_m3, TEST_CASES  # noqa: E402

try:
    from enigma.machine import EnigmaMachine
except ImportError:
    sys.exit("py-enigma non è installato. Esegui: pip install py-enigma")

ROMAN = {"1": "I", "2": "II", "3": "III", "4": "IV", "5": "V"}


def py_machine(order, positions, rings, reflector, pairs):
    """Costruisce una EnigmaMachine py-enigma con le stesse convenzioni.

    `order` è veloce->lento; py-enigma vuole i rotori da sinistra a destra
    (lento->veloce), quindi invertiamo.
    """
    # rotori, ring e display in py-enigma sono da sinistra (lento) a destra
    # (veloce); le nostre convenzioni sono veloce->lento, quindi invertiamo.
    rotors_str = " ".join(ROMAN[n] for n in reversed(order))
    ring_str = " ".join(str(r) for r in reversed(rings))  # 1-based, come da foglio
    plug_str = " ".join(pairs) if pairs else None

    machine = EnigmaMachine.from_key_sheet(
        rotors=rotors_str,
        ring_settings=ring_str,
        reflector=reflector,
        plugboard_settings=plug_str,
    )
    # display da sinistra (lento) a destra (veloce)
    display = "".join(chr(64 + p) for p in reversed(positions))
    machine.set_display(display)
    return machine


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--fuzz", type=int, default=200,
                        help="numero di configurazioni casuali (default 200)")
    args = parser.parse_args()

    failures = 0

    # 1) Vettori noti
    print("1) Vettori noti (TEST_CASES)")
    for order, pos, ring, ref, pairs, text in TEST_CASES:
        expected = py_machine(order, pos, ring, ref, pairs).process_text(text)
        got = encrypt_m3(text, order, pos, ref, pairs, ring)
        status = "PASS" if got == expected else "FAIL"
        if got != expected:
            failures += 1
        print(f"   {status} order={order} pos={pos} ring={ring} ref={ref} "
              f"pairs={pairs} text={text!r} -> {got!r}")

    # 2) Fuzz deterministico
    print(f"2) Fuzz casuale ({args.fuzz} configurazioni)")
    rng = random.Random(20260824)
    letters = string.ascii_uppercase

    for i in range(args.fuzz):
        order = rng.sample("12345", 3)
        positions = [rng.randint(1, 26) for _ in range(3)]
        rings = [rng.randint(1, 26) for _ in range(3)]
        reflector = rng.choice("BC")

        # plugboard: 0-6 coppie di lettere distinte
        pool = list(letters)
        rng.shuffle(pool)
        n_pairs = rng.randint(0, 6)
        pairs = [pool[2 * k] + pool[2 * k + 1] for k in range(n_pairs)]

        text = "".join(rng.choice(letters) for _ in range(rng.randint(5, 40)))

        expected = py_machine(order, positions, rings, reflector, pairs).process_text(text)
        got = encrypt_m3(text, order, positions, reflector, pairs, rings)
        if got != expected:
            failures += 1
            if failures <= 10:
                print(f"   FAIL order={order} pos={positions} ring={rings} "
                      f"ref={reflector} pairs={pairs} text={text!r}\n"
                      f"        py-enigma={expected!r}\n"
                      f"        ours     ={got!r}")

    print()
    if failures == 0:
        print(f"Tutte le {len(TEST_CASES) + args.fuzz} verifiche superate ✅")
        return 0
    print(f"{failures} verifica/e fallite ❌")
    return 1


if __name__ == "__main__":
    sys.exit(main())
