import Foundation

class RefreshService{
    static let shared = RefreshService()
    private init() {}

    func refreshAll() {
        print("🔄 REFRESHING ALL DATA")

        if let email = UserDefaults.standard.string(forKey: "email") {
            Balance.shared.getBalance(email: email)
        }

        TransactionService.shared.loadTransactions()

        let userId = UserDefaults.standard.integer(forKey: "user_id")
        if userId != 0 {
            CardDetailsService.shared.loadCardDetails(userId: userId)
        }
    }
}
