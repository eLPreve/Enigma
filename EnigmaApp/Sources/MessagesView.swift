import SwiftUI
import SwiftData

/// Archivio dei messaggi salvati (porting di `DataBase` dell'app Android).
///
/// Ogni riga mostra il testo cifrato e un riepilogo; toccandola si carica il
/// messaggio (configurazione + testo) nella macchina. Si può salvare il
/// messaggio corrente con il pulsante "+" e cancellare con lo swipe.
struct MessagesView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Environment(EnigmaAppModel.self) private var model
    @Query(sort: \MessageRecord.date, order: .reverse) private var records: [MessageRecord]

    var body: some View {
        List {
            ForEach(records) { record in
                Button {
                    load(record)
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(record.ciphertext.isEmpty ? "—" : record.ciphertext)
                            .font(.body.monospaced())
                            .lineLimit(1)
                        Text(rowText(for: record))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
            }
            .onDelete(perform: delete)
        }
        .navigationTitle("Messaggi salvati")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    saveCurrent()
                } label: {
                    Label("Salva", systemImage: "plus")
                }
                .disabled(model.plaintext.isEmpty && model.ciphertext.isEmpty)
            }
        }
        .overlay {
            if records.isEmpty {
                ContentUnavailableView(
                    "Nessun messaggio salvato",
                    systemImage: "tray",
                    description: Text("Cifra un testo e premi + per salvarlo.")
                )
            }
        }
    }

    // MARK: - Azioni

    private func saveCurrent() {
        context.insert(model.makeRecord())
        try? context.save()
    }

    private func load(_ record: MessageRecord) {
        model.apply(record)
        dismiss()
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            context.delete(records[index])
        }
        try? context.save()
    }

    private func summary(of record: MessageRecord) -> String {
        String(
            format: String(localized: "message.summary"),
            record.reflector,
            record.rotorOrder,
            record.positions
        )
    }

    private func rowText(for record: MessageRecord) -> String {
        let plain = record.plaintext.isEmpty ? String(localized: "(senza testo)") : record.plaintext
        return "\(plain) · \(summary(of: record))"
    }
}
