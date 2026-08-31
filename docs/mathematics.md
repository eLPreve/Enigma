# Il calcolo combinatorio di Enigma

Quante sono le possibili configurazioni (chiavi) di una Enigma M3? La risposta
è il prodotto di **quattro scelte indipendenti**: ordine dei rotori, anelli,
posizioni iniziali e cablaggi della plugboard.

## 1. Ordine dei rotori

Si scelgono **3 rotori tra 5** (I–V) e li si dispone da sinistra a destra.
È una disposizione semplice (i modi di ordinare 3 elementi scelti da 5):

$$D(5,3) = 5 \times 4 \times 3 = 60$$

## 2. Anelli e posizioni iniziali

Ogni rotore ha un anello (26 posizioni) e una posizione iniziale (26 lettere):

- Ring settings: $26^3 = 17.576$
- Posizioni iniziali: $26^3 = 17.576$

## 3. La plugboard (il contributo dominante)

Con **k** cavi che collegano **k** coppie di lettere distinte (ogni lettera
usata al più una volta), il numero di modi è:

$$M(k) = \frac{26!}{(26-2k)! \cdot k! \cdot 2^k}$$

Il perché:

- $\frac{26!}{(26-2k)!}$: si scelgono e si ordinano le $2k$ lettere usate;
- $k!$: l'ordine delle $k$ coppie non conta;
- $2^k$: dentro ogni coppia, l'ordine delle due lettere non conta.

Con i **10 cavi** standard della Wehrmacht:

$$M(10) = \frac{26!}{6! \cdot 10! \cdot 2^{10}} = 150.738.274.937.250$$

Questa è la formula delle permutazioni della plugboard:

![Formula delle permutazioni della plugboard](images/plugboard-permutazioni.png)

I valori per ogni possibile numero di cavi (0–10):

| k | M(k) |
| --- | --- |
| 0 | 1 |
| 1 | 325 |
| 2 | 44.850 |
| 3 | 3.453.450 |
| 4 | 164.038.875 |
| 5 | 5.019.589.575 |
| 6 | 100.391.791.500 |
| 7 | 1.305.093.289.500 |
| 8 | 10.767.019.638.375 |
| 9 | 53.835.098.191.875 |
| 10 | 150.738.274.937.250 |
| **Somma** | **216.751.064.975.576** |

## 4. Il totale

Il numero di configurazioni della macchina è quindi:

- rotori: **60**
- posizioni iniziali: **17.576**
- plugboard (10 cavi): **150.738.274.937.250**

$$60 \times 17.576 \times 150.738.274.937.250 = 158.962.555.217.826.360.000 \approx 1{,}59 \times 10^{20}$$

È il totale delle possibili configurazioni della macchina. Se si contano **anche i ring settings** ($26^3$)
si arriva a circa **$2{,}79 \times 10^{24}$**. La differenza tra i due conti
dipende da cosa si considera "chiave": le posizioni iniziali facevano parte
della chiave di messaggio, gli anelli della chiave di rete.

## Il periodo dei rotori

Anche se gli stati possibili dei tre rotori sono $26^3 = 17.576$, a causa
dell'**intaglio** e del **double stepping** il rotore di mezzo "salta" una
posizione a ogni giro del rotore veloce: il periodo reale è circa
**$26 \times 25 \times 26 = 16.900$**, non 17.576.

## Perché tanta sicurezza apparente?

La cifra di **~$1{,}6 \times 10^{20}$** è enorme, eppure Enigma fu decifrata.
Il motivo è che lo spazio delle permutazioni non è casuale: la **simmetria del
riflettore**, la **regolarità dello stepping** e gli **errori operativi**
tedeschi permisero ad Alan Turing e a Bletchley Park di ridurre drasticamente
lo spazio da provare.
