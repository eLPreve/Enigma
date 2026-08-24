# EnigmaApp — l'app iOS (SwiftUI)

`EnigmaApp/` è l'applicazione iOS costruita sopra **EnigmaCore**. Usa SwiftUI
(`@Observable`), SwiftData per l'archivio e XcodeGen per il progetto.

```text
EnigmaApp/
├── project.yml                  # spec XcodeGen
├── Enigma.xcodeproj             # progetto generato (versionato)
└── Sources/
    ├── EnigmaApp.swift          # entry point + ModelContainer SwiftData
    ├── EnigmaAppModel.swift     # stato condiviso @Observable
    ├── ContentView.swift        # schermata principale
    ├── MachineView.swift        # rotori + lampboard
    ├── RotorSettingsView.swift  # ordine, posizioni, ring settings
    ├── PlugboardSettingsView.swift
    ├── ReflectorSettingsView.swift
    ├── MessageRecord.swift      # modello SwiftData
    ├── MessagesView.swift       # archivio messaggi
    └── Assets.xcassets
```

---

## `EnigmaApp.swift`

**Cosa fa**: entry point dell'app (`@main`). Crea il modello condiviso
(`EnigmaAppModel`) e lo inietta nell'ambiente; configura il **ModelContainer**
SwiftData per `MessageRecord`.

**Come funziona**: `WindowGroup { ContentView().environment(model) }` +
`.modelContainer(for: MessageRecord.self)`.

---

## `EnigmaAppModel.swift`

**Cosa fa**: è il **punto di verità** dell'app: testo, configurazione, stato
della macchina e operazioni. Porta il concetto di "macchina reale" nell'app.

**Stato**:

- `plaintext` / `ciphertext` (il cifrato è `private(set)`): i due testi.
- `rotorOrder`, `positions`, `ringSettings`, `reflector`, `plugboard`,
  `groupInFives`: la configurazione (persistita).
- `activeLamp`: l'ultima lampadina accesa.
- `machine` (`private(set)`): la macchina "fisica" corrente; `rotorDisplay`
  espone le lettere delle finestrelle.

**Operazioni**:

- `press(_:)`: tocco su una lampadina/tastiera → aggiunge la lettera al testo
  in chiaro e aggiorna la macchina.
- `updateLive()`: ricrea la macchina dalla configurazione e la **riproduce**
  sul testo in chiaro, lettera per lettera → aggiorna `ciphertext`,
  `activeLamp` e `machine`. (Enigma è simmetrica: gestisce anche la
  decifratura.)
- `swapToPlaintext()`: porta il cifrato nel campo in chiaro (decifra).
- `clear()`: azzera tutto.
- `makeRecord()` / `apply(_:)`: crea/applica un `MessageRecord` salvato.
- `persistSettings()` / `restoreSettings()`: salvano/ripristinano la
  configurazione in `UserDefaults` (Codable).

**Come funziona la persistenza**: la configurazione è codificata in una struct
`SavedConfiguration` (Codable) salvata in `UserDefaults` con chiave
`enigma.savedConfiguration`. La scrittura è esplicita (`onDisappear` delle
schermate e al cambio del toggle): `didSet` non è utilizzabile sulle proprietà
`@Observable` (la macro le trasforma in proprietà computate).

---

## `ContentView.swift`

**Cosa fa**: schermata principale. Mostra (in un `Form`):

1. la **macchina** (`MachineView`): rotori + lampboard;
2. il campo **testo in chiaro** (filtra a A–Z maiuscole, aggiornamento live);
3. il **testo cifrato** (selezionabile), toggle "Blocchi da 5", `ShareLink`;
4. pulsanti "Usa come testo in chiaro" (decifra) e "Pulisci";
5. la **Configurazione** (riepilogo + link alle impostazioni e all'archivio).

**Come funziona**: legge il modello dall'ambiente; `.onAppear` richiama
`updateLive()` per sincronizzare la macchina (es. dopo un cambio impostazioni);
`.onDisappear` salva la configurazione.

---

## `MachineView.swift`

**Cosa fa**: la "macchina reale" visibile.

- **`RotorsView`**: le tre finestrelle dei rotori con le lettere correnti
  (`display`, veloce → lento).
- **`LampboardView`**: griglia di 26 lampadine. Quella corrispondente a
  `activeLamp` è evidenziata in giallo. **Toccando una lampadina** si invia la
  lettera alla macchina (`onPress` → `model.press`), come premere il tasto.

**Come funziona**: viste "stupide" (pure): ricevono i dati e la callback; non
toccano il modello direttamente. Il modello decide.

---

## Le schermate di impostazione

- **`RotorSettingsView`**: ordine dei 3 rotori (I–V, "veloce → lento"),
  posizioni iniziali (A–Z) e **ring settings** (A–Z). All'uscita salva la
  configurazione.
- **`PlugboardSettingsView`**: 10 coppie di selettori A–Z per i cavi. Coppie con
  lettere uguali non effettuano scambi.
- **`ReflectorSettingsView`**: scelta del riflettore B/C con nota storica.

---

## L'archivio (SwiftData)

- **`MessageRecord`** (`@Model`): un messaggio salvato — testo in chiaro,
  testo cifrato e configurazione completa (ordine, posizioni, anelli,
  riflettore, plugboard) più la data. È il porting della tabella `Texts` del
  database SQLite Android (`MyDatabase`/`Record`).
- **`MessagesView`**: elenco dei messaggi (ordinati per data, più recenti in
  alto). Pulsante "+" per salvare il messaggio corrente, tap per **ricaricare**
  (testo + configurazione), swipe per **cancellare**. Stato vuoto con
  `ContentUnavailableView`.

## Flusso completo di un uso tipico

1. L'utente imposta i rotori/posizioni/anelli, la plugboard e il riflettore
   (persistiti all'uscita).
2. Digita (o tocca la lampboard): la macchina avanza e il cifrato appare live.
3. Attiva "Blocchi da 5" e condivide il messaggio, oppure lo salva
   nell'archivio.
4. Per decifrare: "Usa come testo in chiaro" (il cifrato torna in chiaro).
