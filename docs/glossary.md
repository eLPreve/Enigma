# Glossario

Termini usati nel progetto (macchina Enigma e crittografia).

| Termine | Significato |
| --- | --- |
| **Enigma M3** | Modello militare tedesco a 3 rotori scelti tra I–V, con riflettore B/C. |
| **Walzen** | I rotori della macchina ("cilindri"). |
| **Rotor / rotore** | Disco con 26 contatti su entrambe le facce e un cablaggio interno che scambia le lettere. |
| **Cablaggio** | La mappa che collega i contatti di destra a quelli di sinistra di un rotore. |
| **Intaglio (turnover / notch)** | Posizione su un rotore che, allineata con la leva, fa avanzare il rotore alla sua sinistra. |
| **Pawl / leva** | Meccanismo che scatta il rotore successivo quando il rotore è sull'intaglio. |
| **Double stepping** | Il rotore di mezzo può avanzare due volte di fila quando è sul proprio intaglio. |
| **Ring setting (Ringstellung)** | Anello del rotore, ruotabile rispetto al cablaggio; sposta intaglio e lettere mostrate. |
| **Finestrella** | La finestra in alto che mostra la lettera corrente di ogni rotore. |
| **Riflettore (UKW / Umkehrwalze)** | Disco che rispedisce il segnale attraverso i rotori; rende Enigma simmetrica. |
| **Plugboard (Steckerbrett)** | Pannello a prese con cavi che scambiano coppie di lettere prima e dopo i rotori. |
| **Entry wheel (ETW / Eintrittswalze)** | Disco d'ingresso; nei modelli militari è un passaggio dritto (identità). |
| **Lampboard** | Pannello con 26 lampadine che si accendono alla pressione di un tasto. |
| **Key sheet (foglio di chiavi)** | L'impostazione giornaliera: ordine rotori, posizioni, anelli, riflettore, plugboard. |
| **Cifratura simmetrica / involutoria** | Con le stesse impostazioni, cifrare due volte restituisce l'originale. |
| **Segnale `0–25`** | La rappresentazione interna di una lettera nel motore (A=0 … Z=25). |
| **Vettore di test** | Coppia (testo in chiaro, testo cifrato atteso) per una data configurazione. |
| **py-enigma** | Libreria Python di riferimento (Brian Neal, MIT) usata per validare il motore. |
| **Bombe** | Macchina di Turing & co. per trovare le impostazioni Enigma. (Non implementata qui.) |
| **M4** | Variante Kriegsmarine a 4 rotori (non implementata: questo simulatore è M3). |
