import SwiftUI

/// Schermata principale: la "macchina reale" (rotori + lampboard), i testi in
/// chiaro/cifrato, la condivisione e l'accesso alle impostazioni e all'archivio.
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

                if !model.validationWarnings.isEmpty {
                    Section {
                        ForEach(model.validationWarnings, id: \.self) { warning in
                            Label(warning, systemImage: "exclamationmark.triangle.fill")
                                .font(.footnote)
                                .foregroundStyle(.orange)
                        }
                    } header: {
                        Text("Configurazione non valida")
                    }
                }

                Section("Configurazione") {
                    LabeledContent("Ordine rotori", value: rotorsLabel)
                    LabeledContent("Posizioni", value: positionsLabel)
                    LabeledContent("Anelli (ring)", value: ringsLabel)
                    LabeledContent("Riflettore", value: model.reflector)
                    LabeledContent("Cavi plugboard", value: "\(activePlugboardPairs)/10")

                    NavigationLink("Rotori") { RotorSettingsView() }
                    NavigationLink("Pannello a prese") { PlugboardSettingsView() }
                    NavigationLink("Riflettore") { ReflectorSettingsView() }
                    NavigationLink("Messaggi salvati") { MessagesView() }
                }
            }
            .navigationTitle("Enigma")
            .onAppear { model.updateLive() }
            .onDisappear { model.persistSettings() }
        }
    }

    // MARK: - Etichette riassuntive

    private var rotorsLabel: String {
        model.rotorOrder.map { roman($0) }.joined(separator: " → ")
    }

    private var positionsLabel: String {
        model.positions.map { String(UnicodeScalar($0 + 64)!) }.joined(separator: " ")
    }

    private var ringsLabel: String {
        model.ringSettings.map { String(UnicodeScalar($0 + 64)!) }.joined(separator: " ")
    }

    private var activePlugboardPairs: Int {
        model.plugboard.filter { $0.first != $0.second }.count
    }

    private var shareText: String {
        String(
            format: String(localized: "share.template"),
            model.plaintext,
            model.ciphertext,
            rotorsLabel,
            positionsLabel,
            ringsLabel,
            model.reflector,
            "\(activePlugboardPairs)/10"
        )
    }

    private func roman(_ s: String) -> String {
        ["1": "I", "2": "II", "3": "III", "4": "IV", "5": "V"][s] ?? s
    }
}
