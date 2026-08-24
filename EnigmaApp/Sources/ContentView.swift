import SwiftUI

/// Schermata principale: testo in chiaro, testo cifrato e accesso alle impostazioni.
struct ContentView: View {
    @Environment(EnigmaAppModel.self) private var model

    var body: some View {
        @Bindable var model = model

        NavigationStack {
            Form {
                Section("Testo in chiaro") {
                    TextField("es. HELLO WORLD", text: $model.plaintext)
                        .font(.body.monospaced())
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                        .onChange(of: model.plaintext) { _, newValue in
                            // Solo lettere A-Z, maiuscole (come l'originale che rimuoveva spazi)
                            let filtered = newValue.uppercased().filter { $0.isLetter && $0.isASCII }
                            if filtered != newValue { model.plaintext = filtered }
                        }
                }

                Section("Testo cifrato") {
                    Text(model.ciphertext.isEmpty ? "—" : model.ciphertext)
                        .font(.body.monospaced())
                        .textSelection(.enabled)
                        .foregroundStyle(model.ciphertext.isEmpty ? Color.secondary : Color.primary)
                }

                Section {
                    Button("Cripta", action: model.encrypt)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .disabled(model.plaintext.isEmpty)

                    Button("Pulisci", action: model.clear)
                        .frame(maxWidth: .infinity)
                }

                Section("Configurazione") {
                    LabeledContent("Ordine rotori", value: rotorsLabel)
                    LabeledContent("Posizioni", value: positionsLabel)
                    LabeledContent("Riflettore", value: model.reflector)
                    LabeledContent("Cavi plugboard", value: "\(activePlugboardPairs)/10")

                    NavigationLink("Rotori") { RotorSettingsView() }
                    NavigationLink("Pannello a prese") { PlugboardSettingsView() }
                    NavigationLink("Riflettore") { ReflectorSettingsView() }
                }
            }
            .navigationTitle("Enigma")
        }
    }

    // MARK: - Etichette riassuntive

    private var rotorsLabel: String {
        model.rotorOrder.map { roman($0) }.joined(separator: " → ")
    }

    private var positionsLabel: String {
        model.positions.map { String(UnicodeScalar($0 + 64)!) }.joined(separator: " ")
    }

    private var activePlugboardPairs: Int {
        model.plugboard.filter { $0.first != $0.second }.count
    }

    private func roman(_ s: String) -> String {
        ["1": "I", "2": "II", "3": "III", "4": "IV", "5": "V"][s] ?? s
    }
}
