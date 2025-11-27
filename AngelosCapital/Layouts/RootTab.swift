import SwiftUI

struct RootTab: View {
    @State private var searchText = ""
    @State private var selectedIndex: Int = 0
    @State private var showLens = false
    @ObservedObject var logout = LogoutService.shared

    init() {
        // Unselected icon color (soft finance gray)
        UITabBar.appearance().unselectedItemTintColor =
            UIColor.gray.withAlphaComponent(0.55)

        // Slight blue tint in the material background (premium feel)
        UITabBar.appearance().barTintColor =
            UIColor(red: 0.00, green: 0.23, blue: 0.49, alpha: 0.20)

        // Make tab bar fully glass-like
        UITabBar.appearance().backgroundColor = .clear
    }

    var body: some View {
        ZStack {

            // ===========================================
            // MAIN TAB VIEW
            // ===========================================
            TabView(selection: $selectedIndex) {

                DashboardView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(0)

                PersonalInformationView()
                    .tabItem {
                        Label("Account", systemImage: "person.crop.circle")
                    }
                    .tag(1)

                NavigationStack {
                    AccountHealthView(
                        accountHealth: logout.currentUser?.account_health ?? "C",
                        comments: logout.currentUser?.comments?.components(separatedBy: ",") ?? []
                    )
                    .navigationBarHidden(true)
                    .background(Color.black)
                }
                .tabItem {
                    Label("Health", systemImage: "waveform.path.ecg")
                }
                .tag(2)

            }
            // Search bar + tab bar behavior from iOS 26
            .searchable(text: $searchText)
            .tabBarMinimizeBehavior(.onScrollDown)

            // Selected tab color (your brand blue)
            .tint(.brandBlue)

            // ===========================================
            // LENS POP BUBBLE
            // ===========================================
            VStack {
                Spacer()
                LensBubble(
                    icon: tabIcon(for: selectedIndex),
                    title: tabTitle(for: selectedIndex),
                    show: showLens
                )
                .padding(.bottom, 90)
            }
            .allowsHitTesting(false)
        }

        // Lens pop animation on tab switch
        .onChange(of: selectedIndex) { index in
            popLens()

            // refresh on Home & Account tabs
            if index == 0 || index == 1 {
                RefreshService.shared.refreshAll()
            }
        }

    }

    // MARK: - TAB ICONS
    func tabIcon(for index: Int) -> String {
        switch index {
        case 0: return "house.fill"
        case 1: return "person.crop.circle"
        default: return "waveform.path.ecg"
        }
    }

    func tabTitle(for index: Int) -> String {
        switch index {
        case 0: return "Home"
        case 1: return "Account"
        default: return "Health"
        }
    }

    // MARK: - LENS BUBBLE POP
    func popLens() {
        withAnimation(.spring(response: 0.33, dampingFraction: 0.58)) {
            showLens = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.40) {
            withAnimation(.easeOut(duration: 0.18)) {
                showLens = false
            }
        }
    }
}

// MARK: - BRAND COLOR
extension Color {
    static let brandBlue = Color(red: 0.04, green: 0.52, blue: 1.00) // #0A84FF
}
