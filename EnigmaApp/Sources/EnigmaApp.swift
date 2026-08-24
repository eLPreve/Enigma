import SwiftUI
import SwiftData

@main
struct EnigmaApp: App {
    @State private var model = EnigmaAppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(model)
        }
        .modelContainer(for: MessageRecord.self)
    }
}
