import SwiftUI
import DiaryCore

@main
struct DiaryApp: App {
    @StateObject private var model = DiaryViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
        .windowStyle(.titleBar)
        .defaultSize(width: 900, height: 620)
    }
}
