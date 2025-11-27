import SwiftUI

struct DashboardView: View {

    @State private var showCardDetails = false
    @State private var showDepositPopup = false
    @State private var showLogoutMessage = false

    // SEND POPUP STILL LIVES HERE
    @State private var showSendMoneyPopup = false

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

                    // GRID
                    HStack(alignment: .top, spacing: 12) {

                        VStack(spacing: 12) {
                            BalanceTile()
                                .frame(height: 104)

                            ActivityTile(values: activity)
                                .frame(height: 104)
                        }
                        .frame(maxWidth: .infinity)

                        PaymentTallTile(dueInDays: 6) {
                            showDepositPopup = true
                        }
                        .frame(width: 180, height: 220)
                    }
                    .padding(.horizontal, 20)

                    Text(status)
                        .font(.caption)
                        .foregroundColor(Color.secondary)   // adaptive

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Latest Transactions")
                            .font(.title3)
                            .bold()
                            .foregroundColor(Color.primary)   // adaptive

                        TransactionList()
                    }
                    .padding(.horizontal, 20)

                }
                .padding(.top, 20)
            }
            .refreshable {
                RefreshService.shared.refreshAll()
            }
            .onAppear {
                RefreshService.shared.refreshAll()
                motion.start()
            }
            .background(
                Color(.systemBackground).ignoresSafeArea()   // MAIN FIX
            )
            .toolbar {
                TopToolbar(
                    showSendMoneyPopup: $showSendMoneyPopup,
                    showCardDetails: $showCardDetails,
                    showDepositPopup: $showDepositPopup,
                    onLogout: handleLogout
                )
            }
        }

        // POPUPS ---------------------------------------------------
        .overlay(alignment: .bottom) {
            if showSendMoneyPopup {
                SendMoneyPopup(show: $showSendMoneyPopup)
                    .transition(.move(edge: .bottom))
                    .zIndex(9999)
            }
        }

        .fullScreenCover(isPresented: $showCardDetails) {
            NavigationStack { CardDetails() }
        }

        .fullScreenCover(isPresented: $showDepositPopup) {
            DepositPopup(showDepositPopup: $showDepositPopup)
        }

        .alert("Logout", isPresented: $showLogoutMessage) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Logout successful.")
        }

        .onAppear {
            loadBalances()
            motion.start()
            TransactionService.shared.loadTransactions()
        }
    }

    // LOAD BALANCES
    private func loadBalances() {
        let email = UserDefaults.standard.string(forKey: "email") ?? ""
        if !email.isEmpty {
            balanceService.getBalance(email: email)

            let inv = UserDefaults.standard.string(forKey: "investment_balance") ?? "0.00"
            investmentBalance = "$" + inv
        }
    }

    // LOGOUT
    private func handleLogout() {
        AuthService.shared.logout {
            showLogoutMessage = true
        }
    }
}
