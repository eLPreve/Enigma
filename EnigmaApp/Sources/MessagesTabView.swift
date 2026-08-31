import SwiftUI

/// Tab "Archivio": i messaggi salvati. Dopo aver caricato un messaggio, torna
/// alla tab Macchina.
struct MessagesTabView: View {
    /// Chiamata dopo il caricamento di un messaggio salvato.
    var onApply: (() -> Void)?

    var body: some View {
        NavigationStack {
            MessagesView(onApply: onApply)
        }
    }
}
