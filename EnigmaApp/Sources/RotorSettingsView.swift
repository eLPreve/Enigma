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

            Section {
                Text("Nota: questo porting replica il comportamento dell'app originale (il primo rotore dell'ordine è quello che scatta a ogni lettera). I miglioramenti di fedeltà storica arriveranno in seguito.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Rotori")
    }
}
