import SwiftUI

/// Impostazione delle 10 coppie del pannello a prese (plugboard).
/// Porting di `Switcher_Settings` dell'app Android (i 20 spinner sono diventati
/// 10 coppie di due selettori).
struct PlugboardSettingsView: View {
    @Environment(EnigmaAppModel.self) private var model

    private let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ").map(String.init)
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        @Bindable var model = model

        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach($model.plugboard) { $pair in
                    VStack(spacing: 8) {
                        HStack(spacing: 8) {
                            Picker("Prima lettera", selection: $pair.first) {
                                ForEach(letters, id: \.self) { Text($0).tag($0) }
                            }
                            .pickerStyle(.menu)
                            .labelsHidden()

                            Text("↔")
                                .foregroundStyle(.secondary)

                            Picker("Seconda lettera", selection: $pair.second) {
                                ForEach(letters, id: \.self) { Text($0).tag($0) }
                            }
                            .pickerStyle(.menu)
                            .labelsHidden()
                        }
                    }
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
        }
        .navigationTitle("Pannello a prese")
        .safeAreaInset(edge: .bottom) {
            Text("10 coppie di lettere collegate da cavi. Le coppie con lettere uguali non effettuano scambi.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.bar)
        }
    }
}
