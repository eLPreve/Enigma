# Enigma (iOS app — SwiftUI)

App SwiftUI che simula la macchina Enigma, costruita sopra il motore
**EnigmaCore** (vedi `../EnigmaCore`).

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

```text
EnigmaApp/
├── project.yml                  # spec XcodeGen
├── Enigma.xcodeproj             # progetto generato (versionato)
├── Sources/
│   ├── EnigmaApp.swift          # entry point (@main) + ModelContainer SwiftData
│   ├── EnigmaAppModel.swift     # stato condiviso @Observable + persistenza config
│   ├── ContentView.swift        # schermata principale (macchina + testi)
│   ├── MachineView.swift        # rotori + lampboard interattiva
│   ├── RotorSettingsView.swift  # ordine, posizioni, ring settings
│   ├── PlugboardSettingsView.swift
│   ├── ReflectorSettingsView.swift
│   ├── MessageRecord.swift      # modello SwiftData (messaggio salvato)
│   ├── MessagesView.swift       # archivio messaggi salvati
│   ├── it.lproj/ en.lproj/      # Localizable.strings (italiano, inglese)
│   └── Assets.xcassets
└── UITests/
    └── EnigmaUITests.swift      # test UI (XCUITest)
```

## Test UI

```bash
xcodebuild test -project Enigma.xcodeproj -scheme Enigma \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

## Funzioni

- **Macchina reale interattiva**: rotori (finestrelle) e lampboard a 26 tasti,
  cifratura in tempo reale mentre digiti.
- **Motore M3 storicamente fedele** (`EnigmaCore`): intagli (turnover), double
  stepping e ring settings; vettori di test cross-validati contro py-enigma.
- **Impostazioni**: ordine/posizioni/ring dei 3 rotori, 10 coppie del pannello
  a prese, riflettore B/C. La configurazione viene **salvata** tra gli avvii.
- **Messaggi salvati** (SwiftData): salva/ricarica/cancella messaggi con la
  loro configurazione (porting del database SQLite dell'app Android).
- Condivisione del messaggio (`ShareLink`) e blocchi da 5 lettere.
- **Validazioni**: avvisi per lettere duplicate nella plugboard e rotori
  selezionati più volte.
- **Localizzazione** italiano/inglese (`Localizable.strings`) e **test UI**
  (XCUITest, `UITests/`).
