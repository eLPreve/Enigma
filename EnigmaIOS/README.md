# EnigmaCore (iOS porting)

Porting in **Swift** del motore del simulatore Enigma realizzato come tesina
(2014/2015) per Android. Il motore viene prima isolato in un **Swift Package**
testabile; in una fase successiva verrà costruita l'app **SwiftUI** sopra questo
package.

## Struttura

```
EnigmaIOS/
├── Package.swift                 # Swift Package "EnigmaCore"
├── Sources/
│   └── EnigmaCore/
│       ├── Rotor.swift           # Porting di Rotore.java (rotori I–V)
│       ├── Reflector.swift       # Porting di Reflector.java (riflettori B, C)
│       ├── Plugboard.swift       # Porting di Plugboard.java (pannello prese)
│       └── EnigmaMachine.swift   # Orchestrazione + modello di configurazione
├── Tests/
│   └── EnigmaCoreTests/
│       └── EnigmaMachineTests.swift
└── Tools/
    └── reference_enigma.py       # Referenza Python per generare i vettori di test
```

## Come testare

```bash
cd EnigmaIOS
swift test
```

I test verificano:
- **vettori noti** (generati indipendentemente dalla referenza Python);
- **reciprocità** (cifrare due volte con le stesse impostazioni restituisce l'originale);
- gestione dell'input (maiuscole, caratteri non alfabetici ignorati).

## Nota di fedeltà storica

Questo porting replica **fedelmente il comportamento dell'app originale**
(il primo rotore dell'ordine è quello veloce e scatta dopo ogni lettera; nessun
notch, double stepping o ring setting). I miglioramenti di fedeltà storica
arriveranno in un passo successivo.
