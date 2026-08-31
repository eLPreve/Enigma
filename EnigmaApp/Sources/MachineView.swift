import SwiftUI

/// Vista "macchina reale": finestrelle dei rotori + lampboard.
///
/// Le finestrelle mostrano le posizioni correnti dei rotori (veloce → lento);
/// la lampboard evidenzia l'ultima lampadina accesa e, toccandola, invia la
/// lettera alla macchina come se si premesse il tasto corrispondente.
struct MachineView: View {
    /// Lettere mostrate nei rotori (veloce → lento).
    let display: [Character]
    /// Ultima lampadina accesa.
    let activeLamp: Character?
    /// Azione alla pressione di una lettera.
    let onPress: (Character) -> Void

    var body: some View {
        VStack(spacing: 20) {
            RotorsView(display: display)
            LampboardView(activeLamp: activeLamp, onPress: onPress)
        }
        .padding(.vertical, 8)
    }
}

/// Le tre finestrelle dei rotori (veloce → lento).
struct RotorsView: View {
    let display: [Character]

    var body: some View {
        HStack(spacing: 16) {
            ForEach(Array(display.enumerated()), id: \.offset) { _, letter in
                Text(String(letter))
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .monospaced()
                    .frame(width: 56, height: 64)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(.quaternary, lineWidth: 1)
                    )
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(rotorAccessibilityLabel)
    }

    private var rotorAccessibilityLabel: String {
        guard display.count == 3 else { return display.map(String.init).joined(separator: " ") }
        return String(
            format: String(localized: "Posizione rotori: %@ · %@ · %@"),
            String(display[0]), String(display[1]), String(display[2])
        )
    }
}

/// Lampboard: 26 lampadine; quella accesa è evidenziata. Toccando una lettera
/// la si invia alla macchina (come premere il tasto).
struct LampboardView: View {
    let activeLamp: Character?
    let onPress: (Character) -> Void

    private let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 6)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(letters, id: \.self) { letter in
                let isActive = letter == activeLamp
                Button {
                    onPress(letter)
                } label: {
                    Text(String(letter))
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .monospaced()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            isActive ? Color.yellow : Color(.secondarySystemBackground),
                            in: RoundedRectangle(cornerRadius: 10)
                        )
                        .foregroundStyle(isActive ? Color.black : Color.primary)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(isActive ? Color.orange : Color.clear, lineWidth: 2)
                        )
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Premi \(String(letter))")
                .accessibilityIdentifier("lamp-\(letter)")
            }
        }
    }
}
