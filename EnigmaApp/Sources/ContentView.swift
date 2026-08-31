import SwiftUI

/// Tab "Macchina": la macchina reale (rotori + lampboard) e i testi in
/// chiaro/cifrato. Le impostazioni e l'archivio sono nelle altre tab.
struct ContentView: View {
    @Environment(EnigmaAppModel.self) private var model

    var body: some View {
        @Bindable var model = model

        NavigationStack {
            Form {
                Section {
                    MachineView(
                        display: model.rotorDisplay,
                        activeLamp: model.activeLamp,
                        onPress: { model.press($0) }
                    )
                    .frame(maxWidth: .infinity)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)

                Section("Testo in chiaro") {
                    TextField("es. HELLO WORLD", text: $model.plaintext)
                        .font(.body.monospaced())
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                        .accessibilityIdentifier("plaintextField")
                        .onChange(of: model.plaintext) { _, newValue in
                            // Solo lettere A-Z maiuscole; il testo cifrato si
                            // aggiorna in tempo reale.
                            let filtered = newValue.uppercased().filter { $0.isLetter && $0.isASCII }
                            if filtered != newValue {
                                model.plaintext = filtered
                            } else {
                                model.updateLive()
                            }
                        }
                }

                Section("Testo cifrato") {
                    Text(model.formattedCiphertext.isEmpty ? "—" : model.formattedCiphertext)
                        .font(.body.monospaced())
                        .textSelection(.enabled)
                        .accessibilityIdentifier("ciphertext")
                        .foregroundStyle(model.ciphertext.isEmpty ? Color.secondary : Color.primary)

                    Toggle("Blocchi da 5", isOn: Binding(
                        get: { model.groupInFives },
                        set: { model.groupInFives = $0; model.persistSettings() }
                    ))

                    ShareLink(item: shareText) {
                        Label("Condividi messaggio", systemImage: "square.and.arrow.up")
                    }
                    .disabled(model.ciphertext.isEmpty)
                }

                Section {
                    Button("Usa come testo in chiaro", action: model.swapToPlaintext)
                        .frame(maxWidth: .infinity)
                        .disabled(model.ciphertext.isEmpty)

                    Button("Pulisci", action: model.clear)
                        .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Enigma")
            .onAppear { model.updateLive() }
            .onDisappear { model.persistSettings() }
        }
    }

    private var shareText: String {
        String(
            format: String(localized: "share.template"),
            model.plaintext,
            model.ciphertext,
            model.rotorsLabel,
            model.positionsLabel,
            model.ringsLabel,
            model.reflector,
            "\(model.activePlugboardCount)/10"
        )
    }
}
