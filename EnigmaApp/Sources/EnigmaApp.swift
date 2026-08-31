import SwiftUI
import SwiftData

@main
struct EnigmaApp: App {
    @State private var model = EnigmaAppModel()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(model)
        }
        .modelContainer(for: MessageRecord.self)
    }
}
