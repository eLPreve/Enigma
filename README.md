# Enigma — simulatore della macchina Enigma M3

Una simulazione **storicamente fedele della Enigma M3** (la macchina di cifratura
della Wehrmacht), originariamente un simulatore per Android (2014/2015) e ora
riscritta per **iOS** in **Swift/SwiftUI**, con un motore verificato contro la
libreria di riferimento [py-enigma](https://github.com/bgirardot/py-enigma).

L'app riproduce la macchina reale: **rotori con intagli e double stepping**,
**ring settings**, **plugboard** e **lampboard interattiva**, con cifratura in
tempo reale.

## Funzionalità

- Motore **Enigma M3 storicamente fedele**: intagli (I→Q, II→E, III→V, IV→J,
  V→Z), double stepping e ring settings; cross-validato contro **py-enigma**
  (508/508 verifiche).
- **Macchina interattiva**: rotori (finestre) e **lampboard** a 26 tasti;
  cifratura in tempo reale mentre digiti.
- Configurazione completa: ordine/posizioni/ring dei rotori, plugboard (10
  coppie), riflettore B/C; **salvata** tra gli avvii.
- **Archivio messaggi** (SwiftData): salva/ricarica/cancella messaggi con la
  loro configurazione.
- Condivisione del messaggio, blocchi da 5 lettere, localizzazione **IT/EN**,
  test automatici (motore + UI).

## Requisiti

- **Xcode 15+** (progetto iOS 17+, Swift 5.9).
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`)
  per rigenerare il progetto dopo l'aggiunta di nuovi file.

## Installazione ed esecuzione

```bash
# 1. Clona il repository
git clone <url-repository>
cd Enigma

# 2. Apri l'app in Xcode
open EnigmaApp/Enigma.xcodeproj
# poi premi ▶ (Run) su un simulatore iPhone

# Oppure: rigenera il progetto con XcodeGen e aprilo
cd EnigmaApp
xcodegen generate --spec project.yml
open Enigma.xcodeproj
```

## Test

```bash
# Motore (Swift Package EnigmaCore): vettori, reciprocità, turnover
cd EnigmaCore && swift test

# Motore senza Xcode completo
cd EnigmaCore && swift run EnigmaCLI

# Cross-validazione contro py-enigma
# (una sola volta: python3 -m venv .venv && .venv/bin/pip install py-enigma)
.venv/bin/python EnigmaCore/Tools/validate_m3.py --fuzz 500

# App: test UI su simulatore
cd EnigmaApp && xcodebuild test -project Enigma.xcodeproj -scheme Enigma \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

## Struttura del progetto

```text
Enigma/
├── EnigmaCore/        # Swift Package: il motore Enigma M3 (senza UI)
├── EnigmaApp/         # app iOS SwiftUI (usa EnigmaCore)
└── docs/              # documentazione tecnica + immagini storiche
```

## Documentazione

- README di dettaglio: [`EnigmaCore/README.md`](EnigmaCore/README.md) e
  [`EnigmaApp/README.md`](EnigmaApp/README.md).
- Documentazione tecnica (architettura, meccanica M3, **calcolo combinatorio**,
  componenti, validazione, glossario): [`docs/`](docs/README.md).

## Crediti

Progetto originale: simulatore della macchina Enigma di **Nicola Prevedello**
(2014/2015). Il motore è ispirato al modello di **py-enigma** (Brian Neal, MIT
License).
