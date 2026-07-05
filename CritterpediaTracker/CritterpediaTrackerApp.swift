import SwiftUI

@main
struct CritterpediaTrackerApp: App {
    @StateObject private var caughtStore = CaughtStore()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(caughtStore)
        }
    }
}
