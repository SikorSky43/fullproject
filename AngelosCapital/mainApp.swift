import SwiftUI

@main
struct mainApp: App {
    @StateObject var session = LogoutService.shared
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    LandingView(showSplash: $showSplash)
                        .transition(.opacity)
                } else {
                    if session.isLoggedIn {
                        RootTab()
                            .transition(.opacity)
                    } else {
                        LoginView()
                            .transition(.opacity)
                    }
                }
            }
            .animation(.easeInOut(duration: 0.6), value: showSplash)
            .animation(.easeInOut(duration: 0.6), value: session.isLoggedIn)
        }
    }
}
