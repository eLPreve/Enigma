# EnigmaCore — il motore (Swift Package)

`EnigmaCore/` è lo Swift Package **EnigmaCore**: contiene tutta la logica della
macchina, senza UI. Piattaforme dichiarate: iOS 17+, macOS 14+.

```text
EnigmaCore/
├── Package.swift                 # manifest del package (library EnigmaCore)
├── Sources/EnigmaCore/
│   ├── Rotor.swift               # rotore M3
│   ├── Reflector.swift           # riflettore B/C
│   ├── Plugboard.swift           # pannello a prese
│   └── EnigmaMachine.swift       # macchina + configurazione
├── Sources/EnigmaCLI/main.swift  # runner di verifica da terminale
├── Tests/EnigmaCoreTests/        # suite XCTest
└── Tools/                        # referenze Python e validazione
```

I componenti sono descritti qui sotto, **cosa fanno** e **come funzionano**.

---

## `EnigmaConfiguration` (in `EnigmaMachine.swift`)

**Cosa fa**: descrive un'impostazione completa della macchina (il "foglio di
chiavi" digitale).

| Proprietà | Significato | Default |
| --- | --- | --- |
| `rotorOrder` | Ordine dei rotori dal **veloce** al lento, `"1"…"5"` | `["1","2","3"]` |
| `positions` | Posizioni iniziali mostrate, `1…26` (1 = A) | `[1,1,1]` |
| `ringSettings` | Ring settings, `1…26` (1 = A) | `[1,1,1]` |
| `reflector` | Riflettore `"B"` o `"C"` | `"B"` |
| `plugboardPairs` | Coppie della plugboard, es. `["AB","CD"]` | `[]` |

**Come funziona**: è un semplice struct `Equatable`/inizializzabile con default;
`EnigmaMachine(configuration:)` lo consuma.

---

## `Rotor` (in `Rotor.swift`)

**Cosa fa**: modella un rotore M3 (I–V) con cablaggio, intaglio, ring setting e
posizione. È il cuore della cifratura.

**Come funziona** (modello identico a py-enigma):

- `entryMap[pin]` = contatto di sinistra collegato al pin di destra `pin`
  (indici `0–25`); `exitMap` è il cablaggio inverso.
- `pos` è la posizione interna sull'asse, `display` la lettera in finestrella
  (`display = (pos + ringSetting) mod 26`).
- `signalIn(_:)` (destra→sinistra) e `signalOut(_:)` (sinistra→destra)
  applicano il cablaggio tenendo conto di rotazione e anello.
- `isAtNotch()` è true se la lettera mostrata è l'intaglio (I→Q, II→E, III→V,
  IV→J, V→Z): al prossimo tasto farà avanzare il rotore a sinistra.
- `step()` avanza `pos` di 1.

**Dati**: le tabelle di cablaggio e intaglio sono in `table(for:)` (dati
storici, fonte Rijmenants). Il valore `"0"` produce un rotore statico
(identità, senza intaglio).

---

## `Reflector` (in `Reflector.swift`)

**Cosa fa**: modella il riflettore UKW (B o C).

**Come funziona**: a differenza dei rotori **non ruota e non ha ring**; è una
semplice mappa di cablaggio. `signalIn(_:)` applica il cablaggio, `signalOut(_:)`
l'inverso (necessario per completezza; in pratica il segnale usa solo
`signalIn` sul riflettore). Il fatto che nessuna lettera sia collegata a sé
stessa rende Enigma **simmetrica**.

---

## `Plugboard` (in `Plugboard.swift`)

**Cosa fa**: modella il pannello a prese (Steckerbrett), fino a 10 cavi che
scambiano coppie di lettere.

**Come funziona**: `wiringMap[n]` è la lettera con cui `n` è scambiata.
`configure("AB")` imposta `wiringMap[A]=B` e `wiringMap[B]=A`; `signal(_:)`
applica lo scambio. Coppie con lettere uguali vengono ignorate (come
nell'originale).

---

## `EnigmaMachine` (in `EnigmaMachine.swift`)

**Cosa fa**: orchestrazione della macchina M3: costruisce i componenti dalla
configurazione, esegue lo stepping e il segnale elettrico.

**Come funziona**:

- **Init**: configura la plugboard, crea i rotori (veloce → lento) applicando
  ring settings e posizioni iniziali, crea il riflettore.
- `encrypt(_:)`: normalizza l'input (maiuscole, solo A–Z), poi per ogni lettera
  chiama `keyPress`.
- `keyPress(_:)` (pubblica, mutante): esegue la sequenza **identica a
  py-enigma**:
  1. **Stepping** (prima della cifratura): il veloce avanza sempre; il medio se
     `veloce.isAtNotch() || medio.isAtNotch()` (double stepping); il lento se
     `medio.isAtNotch()`.
  2. **Segnale**: plugboard → rotori destra→sinistra → riflettore → rotori
     sinistra→destra → plugboard, e restituisce la lampadina accesa.
- `display`: le lettere correnti delle finestrelle (veloce → lento), esposte
  alla UI.

**Nota**: `encrypt` lavora su una copia mutabile di sé stessa: ogni chiamata
riparte dalla configurazione (niente stato residuo tra una cifratura e l'altra).
`keyPress` invece è esposta per la cifratura **incrementale** usata dall'app.

---

## `EnigmaCLI` (in `Sources/EnigmaCLI/main.swift`)

**Cosa fa**: runner di verifica da terminale che esegue lo stesso set di
controlli della suite XCTest, ma **senza richiedere Xcode completo** (su
macchine con solo Command Line Tools il modulo XCTest non è disponibile).

**Uso**: `cd EnigmaCore && swift run EnigmaCLI`.

---

## Correttezza

La correttezza del motore è garantita da una catena di validazioni descritta in
[Validazione e test](testing.md): referenza Python → cross-validazione contro
py-enigma → vettori nei test → suite XCTest/CLI.
