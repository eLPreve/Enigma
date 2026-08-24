import SwiftUI

/// Impostazione dell'ordine e delle posizioni iniziali dei tre rotori.
/// Porting di `Rotor_Settings` dell'app Android.
struct RotorSettingsView: View {
    @Environment(EnigmaAppModel.self) private var model

    private let rotorTags = ["1", "2", "3", "4", "5"]
    private let rotorLabels = ["I", "II", "III", "IV", "V"]
    private let positions = Array(1...26)
    private let positionLabels = (65...90).map { String(UnicodeScalar($0)!) }

    var body: some View {
        @Bindable var model = model

        Form {
            Section("Ordine dei rotori (veloce → lento)") {
                ForEach(0..<3, id: \.self) { index in
                    Picker("Rotore \(index + 1)", selection: $model.rotorOrder[index]) {
                        ForEach(0..<rotorTags.count, id: \.self) { i in
                            Text(rotorLabels[i]).tag(rotorTags[i])
                        }
                    }
                }
            }

            Section("Posizioni iniziali") {
                ForEach(0..<3, id: \.self) { index in
                    Picker("Rotore \(index + 1)", selection: $model.positions[index]) {
                        ForEach(0..<positions.count, id: \.self) { i in
                            Text(positionLabels[i]).tag(positions[i])
                        }
                    }
                }
            }

            Section("Ring settings (Ringstellung)") {
                ForEach(0..<3, id: \.self) { index in
                    Picker("Rotore \(index + 1)", selection: $model.ringSettings[index]) {
                        ForEach(0..<26, id: \.self) { i in
                            Text(positionLabels[i]).tag(i + 1)
                        }
                    }
                }
            }

            Section {
                Text("Il motore replica la Enigma M3 reale: i rotori hanno un intaglio (I→Q, II→E, III→V, IV→J, V→Z) che fa avanzare il rotore successivo, con double stepping. Il ring setting (Ringstellung) sposta l'intaglio e il cablaggio rispetto all'alfabeto.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            if !rotorWarnings.isEmpty {
                Section {
                    ForEach(rotorWarnings, id: \.self) { warning in
                        Label(warning, systemImage: "exclamationmark.triangle.fill")
                            .font(.footnote)
                            .foregroundStyle(.orange)
                    }
                }
            }
        }
        .navigationTitle("Rotori")
        .onDisappear { model.persistSettings() }
    }

    /// Avvisi relativi all'ordine dei rotori (rotori selezionati più volte).
    private var rotorWarnings: [String] {
        model.validationWarnings.filter { $0.hasPrefix("Rotore") }
    }
}
