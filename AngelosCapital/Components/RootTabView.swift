import SwiftUI

struct RootTabView: View {
    @State private var searchText = ""
    @State private var selectedIndex: Int = 0
    @State private var showLens = false

    var body: some View {

        ZStack {
            // MAIN TABVIEW
            TabView(selection: $selectedIndex) {

                DashboardView()
                    .tabItem { Label("Home", systemImage: "house") }
                    .tag(0)

                PersonalInformationView()
                    .tabItem { Label("Account", systemImage: "person.crop.circle") }
                    .tag(1)

                NavigationStack { Color.black }
                    .tabItem { Label("Search", systemImage: "magnifyingglass") }
                    .tag(2)
            }
            .searchable(text: $searchText)
            .tabBarMinimizeBehavior(.onScrollDown)
            .onChange(of: selectedIndex) { _ in
                popLens()
            }

            // OPTIONAL: LENS BUBBLE EFFECT (KEEP or REMOVE)
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
    }

    // MARK: - TAB METADATA
    func tabIcon(for index: Int) -> String {
        switch index {
        case 0: return "house.fill"
        case 1: return "person.crop.circle"
        default: return "magnifyingglass"
        }
    }

    func tabTitle(for index: Int) -> String {
        switch index {
        case 0: return "Home"
        case 1: return "Account"
        default: return "Search"
        }
    }

    // MARK: - POP ANIMATION
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
