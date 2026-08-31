import SwiftUI

/// Le sezioni principali dell'app, raggiungibili dalla barra delle tab.
enum AppTab: Hashable {
    case machine
    case configuration
    case archive
}

/// Struttura a tab (pattern iOS classico): la barra in basso permette di
/// passare tra Macchina, Configurazione e Archivio.
struct RootTabView: View {
    @State private var selectedTab: AppTab = .machine

    var body: some View {
        TabView(selection: $selectedTab) {
            ContentView()
                .tabItem { Label("Macchina", systemImage: "keyboard") }
                .tag(AppTab.machine)

            ConfigurationTabView()
                .tabItem { Label("Configurazione", systemImage: "slider.horizontal.3") }
                .tag(AppTab.configuration)

            MessagesTabView(onApply: { selectedTab = .machine })
                .tabItem { Label("Archivio", systemImage: "tray.full") }
                .tag(AppTab.archive)
        }
    }
}
