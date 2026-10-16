import SwiftUI

@main
struct AIBoardsPanelsApp: App {
    init() {
        AppFont.register()   // register bundled Inter TTFs (falls back to system if absent)
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
