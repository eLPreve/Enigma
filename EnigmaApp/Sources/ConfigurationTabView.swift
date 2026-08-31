import SwiftUI

/// Tab "Configurazione": tutte le impostazioni della macchina in un'unica
/// schermata — riepilogo, accesso alle schermate di dettaglio e avvisi di
/// validazione.
struct ConfigurationTabView: View {
    // MARK: - Stato condiviso

    @Environment(EnigmaAppModel.self) private var model

    var body: some View {
        NavigationStack {
            Form {
                Section("Riepilogo") {
                    LabeledContent("Ordine rotori", value: model.rotorsLabel)
                    LabeledContent("Posizioni", value: model.positionsLabel)
                    LabeledContent("Anelli (ring)", value: model.ringsLabel)
                    LabeledContent("Riflettore", value: model.reflector)
                    LabeledContent("Cavi plugboard", value: "\(model.activePlugboardCount)/10")
                }

                Section("Impostazioni") {
                    NavigationLink("Rotori") { RotorSettingsView() }
                    NavigationLink("Pannello a prese") { PlugboardSettingsView() }
                    NavigationLink("Riflettore") { ReflectorSettingsView() }
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
            }
            .navigationTitle("Configurazione")
            .onDisappear { model.persistSettings() }
        }
    }
}
