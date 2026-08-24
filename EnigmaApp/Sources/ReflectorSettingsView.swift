import SwiftUI

/// Scelta del riflettore (B o C). Porting di `Reflector_Settings`.
struct ReflectorSettingsView: View {
    @Environment(EnigmaAppModel.self) private var model

    var body: some View {
        @Bindable var model = model

        Form {
            Picker("Riflettore", selection: $model.reflector) {
                Text("B").tag("B")
                Text("C").tag("C")
            }
            .pickerStyle(.segmented)

            Section {
                Text("Il riflettore rispedisce il segnale attraverso i rotori, rendendo Enigma simmetrica (cifratura = decifratura). Il modello B è il più diffuso; il C è una variante più rara.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Riflettore")
    }
}
