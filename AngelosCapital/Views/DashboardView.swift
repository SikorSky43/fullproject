import SwiftUI

struct DashboardView: View {
    @State private var showCardDetails = false
    @State private var showDepositPopup = false
    @State private var showLogoutMessage = false

    @StateObject private var logoutService = LogoutService.shared
    @ObservedObject private var balanceService = Balance.shared
    @StateObject private var motion = MotionManager()

    @State private var investmentBalance: String = "£0.00"

    let status = "Updated just now"
    let activity: [Double] = [0.2, 0.5, 0.8, 1.0, 0.65, 0.55, 0.7, 0.4, 0.35, 0.3, 0.25]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {

                    // Apple Cash card
                    GlassCard(focalPointOffset: $motion.focalPointOffset)

                    // =========================================
                    // MAIN GRID LAYOUT (APPLE CARD STYLE)
                    // =========================================
                    HStack(alignment: .top, spacing: 12) {

                        // LEFT COLUMN (two separate compact tiles)
                        VStack(spacing: 12) {

                            BalanceTile(investment: investmentBalance)
                                .frame(height: 104)          // FIXED

                            ActivityTile(values: activity)
                                .frame(height: 104)         // FIXED
                        }

                        .frame(maxWidth: .infinity)

                        // RIGHT COLUMN — Payment tall tile (same height as both left tiles)
                        PaymentTallTile(dueInDays: 6) {
                            showDepositPopup = true
                        }
                        .frame(width: 180, height: 220)   // EXACT FIX
                    }
                    .padding(.horizontal, 20)

                    // =========================================

                    Text(status)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.leading, 20)

                    // Transactions
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Latest Transactions")
                            .font(.title3).bold()
                            .foregroundColor(.white)

                        TransactionList()
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top, 20)
            }
            .background(Color.black.ignoresSafeArea())
            .toolbar {
                TopToolbar(
                    showCardDetails: $showCardDetails,
                    showDepositPopup: $showDepositPopup,
                    onLogout: handleLogout
                )
            }
        }
        .fullScreenCover(isPresented: $showCardDetails) {
            NavigationStack {
                CardDetails()
                    .transition(.move(edge: .leading))
            }
        }
        .fullScreenCover(isPresented: $showDepositPopup) {
            DepositPopup(showDepositPopup: $showDepositPopup)
        }
        .alert("Logout", isPresented: $showLogoutMessage) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Logout successful.")
        }
        .onAppear {
            loadBalances()
            motion.start()

            // load history
            TransactionService.shared.loadTransactions()

            // OPTIONAL — If you use /api/transactions directly:
            // HistoryComp.shared.loadTransactions()
        }

    }

    // MARK: - Load Balance & Investment
    private func loadBalances() {
        let email = UserDefaults.standard.string(forKey: "email") ?? ""

        if !email.isEmpty {
            balanceService.getBalance(email: email)

            let inv = UserDefaults.standard.string(forKey: "investment_balance") ?? "0.00"
            investmentBalance = "$" + inv
        }
    }

    // MARK: - Logout
    private func handleLogout() {
        AuthService.shared.logout {
            showLogoutMessage = true
        }
    }
}
