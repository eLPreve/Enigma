# EnigmaCore (Enigma M3 storicamente fedele)

Porting in **Swift** del motore di un simulatore Enigma originale (2014/2015)
per Android, ora evoluto in un **simulatore della Enigma M3 (Wehrmacht)
storicamente fedele**.

Il motore replica il comportamento reale della macchina:

- **intagli (turnover)** dei rotori I–V: I→Q, II→E, III→V, IV→J, V→Z;
- **double stepping** del rotore di mezzo;
- **ring settings (Ringstellung)**;
- riflettori B/C e plugboard (Steckerbrett).

L'implementazione è **identica alla libreria di riferimento py-enigma** (Brian
Neal, MIT) ed è cross-validata automaticamente contro di essa (vedi sotto).
Enigma è simmetrica: con le stesse impostazioni cifrare due volte restituisce
l'originale (cifratura = decifratura).

## Struttura

```text
EnigmaCore/
├── Package.swift                 # Swift Package "EnigmaCore"
├── Sources/
│   ├── EnigmaCore/
│   │   ├── Rotor.swift           # Rotore M3 (cablaggio, intaglio, ring, posizione)
│   │   ├── Reflector.swift       # Riflettore B/C
│   │   ├── Plugboard.swift       # Pannello a prese (Steckerbrett)
│   │   └── EnigmaMachine.swift   # Orchestrazione M3 + modello di configurazione
│   └── EnigmaCLI/
│       └── main.swift            # Runner di verifica senza Xcode completo
├── Tests/
│   └── EnigmaCoreTests/
│       └── EnigmaMachineTests.swift
└── Tools/
    ├── reference_enigma.py       # Referenza ORIGINALE (app Android) — storico
    ├── reference_enigma_m3.py    # Referenza M3 FEDELE (genera i vettori di test)
    └── validate_m3.py            # Cross-validazione M3 contro py-enigma
```

## Come testare

```bash
cd EnigmaCore
swift test                 # suite XCTest (vettori, reciprocità, turnover, input)
swift run EnigmaCLI        # stesso set di verifiche, senza richiedere Xcode completo
```

I test verificano:

- **vettori noti M3** (generati da `Tools/reference_enigma_m3.py`);
- **reciprocità** (cifrare due volte con le stesse impostazioni restituisce l'originale);
- **ring settings** (cambiano il testo cifrato);
- **stepping fedele** (l'intaglio fa avanzare il rotore di mezzo);
- gestione dell'input (maiuscole, caratteri non alfabetici ignorati).

## Cross-validazione contro py-enigma

La referenza M3 e i vettori di test sono validati contro la libreria
**py-enigma** (la più diffusa simulazione di riferimento):

```bash
cd Enigma
python3 -m venv .venv
.venv/bin/pip install py-enigma
.venv/bin/python EnigmaCore/Tools/validate_m3.py --fuzz 500
```

Il tool confronta `reference_enigma_m3.encrypt_m3` con py-enigma su vettori noti
e su centinaia di configurazioni casuali (fuzz).

## Nota sulle due referenze Python

- `reference_enigma.py` documenta la variante **originale** dell'app Android
  (2014/2015): il primo rotore dell'ordine scatta a ogni lettera, nessun
  intaglio/double stepping/ring setting. È mantenuta come riferimento storico.
- `reference_enigma_m3.py` è la referenza **M3 fedele** usata per i vettori
  correnti dei test.
