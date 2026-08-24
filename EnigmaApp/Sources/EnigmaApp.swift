import SwiftUI

@main
struct EnigmaApp: App {
    @State private var model = EnigmaAppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(model)
        }
    }
}
