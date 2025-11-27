import SwiftUI

struct RootTab: View {
    @State private var searchText = ""
    @State private var selectedIndex: Int = 0
    @State private var showLens = false
    @ObservedObject var logout = LogoutService.shared

    // THEME STORAGE
    @AppStorage("app_color_scheme") private var appColorScheme: String = "system"

    init() {
        UITabBar.appearance().unselectedItemTintColor =
            UIColor.gray.withAlphaComponent(0.55)

        UITabBar.appearance().barTintColor =
            UIColor(red: 0.00, green: 0.23, blue: 0.49, alpha: 0.20)

        UITabBar.appearance().backgroundColor = .clear
    }

    var body: some View {
        ZStack {

            TabView(selection: $selectedIndex) {

                // HOME TAB
                ZStack {
                    Color(.systemBackground).ignoresSafeArea()
                    DashboardView()
                }
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

                // ACCOUNT TAB
                ZStack {
                    Color(.systemBackground).ignoresSafeArea()
                    PersonalInformationView()
                }
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle")
                }
                .tag(1)

                // HEALTH TAB
                ZStack {
                    Color(.systemBackground).ignoresSafeArea()
                    NavigationStack {
                        AccountHealthView(
                            accountHealth: logout.currentUser?.account_health ?? "C",
                            comments: logout.currentUser?.comments?.components(separatedBy: ",") ?? []
                        )
                        .navigationBarHidden(true)
                    }
                }
                .tabItem {
                    Label("Health", systemImage: "waveform.path.ecg")
                }
                .tag(2)
            }

            .searchable(text: $searchText)
            .tabBarMinimizeBehavior(.onScrollDown)
            .tint(.brandBlue)

            // LENS BUBBLE
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

        .onChange(of: selectedIndex) { index in
            popLens()
            if index == 0 || index == 1 {
                RefreshService.shared.refreshAll()
            }
        }

        // 🔥 Apply THEME here too
        .preferredColorScheme(
            appColorScheme == "light" ? .light :
            appColorScheme == "dark"  ? .dark  : nil
        )
    }

    // MARK: - Tab Helpers
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

    // MARK: - Lens Pop Animation
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

extension Color {
    static let brandBlue = Color(red: 0.04, green: 0.52, blue: 1.00)
}
