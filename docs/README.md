# Documentazione tecnica — Enigma

Questa cartella raccoglie la documentazione tecnica del progetto. Ogni documento
spiega **cosa fa** e **come funziona** ogni componente.

## Indice

| Documento | Contenuto |
| --- | --- |
| [Architettura](architecture.md) | Struttura del repository, perché due cartelle, flusso dei dati, build e test |
| [La macchina Enigma M3](enigma-m3.md) | Cos'è l'Enigma M3 e come funziona (rotori, plugboard, riflettore, intagli, double stepping, ring settings) |
| [Il calcolo combinatorio](mathematics.md) | Quante chiavi ha Enigma: rotori, anelli, posizioni e la formula della plugboard |
| [EnigmaCore (motore)](enigmacore.md) | I componenti del motore Swift: `Rotor`, `Reflector`, `Plugboard`, `EnigmaMachine`, `EnigmaConfiguration` |
| [EnigmaApp (app iOS)](enigmaapp.md) | I componenti dell'app SwiftUI: `EnigmaAppModel`, `ContentView`, `MachineView`, impostazioni, archivio |
| [Validazione e test](testing.md) | Come il motore è verificato: referenza Python, py-enigma, vettori, CLI, XCTest |
| [Glossario](glossary.md) | Termini della macchina Enigma e della crittografia usati nel progetto |

## Mappa del repository

```text
Enigma/
├── EnigmaCore/           # Swift Package (il motore, senza UI)
│   ├── Sources/EnigmaCore/   # Rotor, Reflector, Plugboard, EnigmaMachine
│   ├── Sources/EnigmaCLI/    # runner di verifica da terminale
│   ├── Tests/                # suite XCTest
│   └── Tools/                # referenze Python + validazione vs py-enigma
├── EnigmaApp/            # applicazione iOS SwiftUI (usa EnigmaCore)
│   └── Sources/          # App, Model, Views, modello SwiftData
└── docs/                 # questa documentazione
```

## Come leggere i documenti

- **Architettura** e **Enigma M3** danno il contesto generale.
- **EnigmaCore** e **EnigmaApp** descrivono il codice file per file.
- **Validazione e test** spiega come la correttezza è garantita.
- **Glossario** è il riferimento rapido per i termini.
