# Enigma (iOS app — SwiftUI)

App SwiftUI che simula la macchina Enigma, costruita sopra il motore
**EnigmaCore** (vedi `../EnigmaIOS`).

## Requisiti

- macOS con **Xcode** installato (il progetto usa iOS 17+).
- Il progetto viene generato da **XcodeGen** (`brew install xcodegen`).

## Aprire l'app

Il progetto `Enigma.xcodeproj` è già generato e versionato: aprilo con Xcode
e premi ▶ (Run). In alternativa, rigeneralo da zero:

```bash
cd EnigmaApp
xcodegen generate --spec project.yml
open Enigma.xcodeproj
```

## Compilare da terminale (simulatore)

```bash
xcodebuild -project Enigma.xcodeproj -scheme Enigma \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build
```

## Struttura

```
EnigmaApp/
├── project.yml                  # spec XcodeGen
├── Enigma.xcodeproj             # progetto generato (versionato)
└── Sources/
    ├── EnigmaApp.swift          # entry point (@main)
    ├── EnigmaAppModel.swift     # stato condiviso @Observable + configurazione
    ├── ContentView.swift        # schermata principale (cifratura)
    ├── RotorSettingsView.swift  # ordine + posizioni rotori
    ├── PlugboardSettingsView.swift
    ├── ReflectorSettingsView.swift
    └── Assets.xcassets
```

## Funzioni

- Cifratura/decifratura (Enigma è simmetrica) con la configurazione scelta.
- Impostazioni: ordine e posizioni dei 3 rotori, 10 coppie del pannello a prese, riflettore B/C.
- Porting dell'app Android originale (2014/2015): comportamento del motore identico,
  verificato con i vettori di test di `EnigmaCore`.
