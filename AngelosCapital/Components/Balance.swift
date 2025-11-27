import Foundation
internal import Combine

// ------------------------------------------------------
// MARK: - Notification Name (MUST be outside the class)
// ------------------------------------------------------
extension Notification.Name {
    static let didUpdateBalance = Notification.Name("didUpdateBalance")
}

// ------------------------------------------------------
// MARK: - Balance Service
// ------------------------------------------------------
class Balance: ObservableObject {

    static let shared = Balance()
    private init() {}

    @Published var balance: String = "£0.00"   // Card balance
    @Published var invest: String = "£0.00"    // Investment balance

    // --------------------------------------------------
    // MARK: - Main API Call
    // --------------------------------------------------
    func getBalance(email: String) {

        guard let url = URL(string: "https://angeloscapital.com/api/balance") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["email": email]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }

            struct BalanceResponse: Codable {
                let status: String
                let card_balance: String
                let investment_balance: String
            }

            do {
                let decoded = try JSONDecoder().decode(BalanceResponse.self, from: data)

                DispatchQueue.main.async {

                    // SwiftUI – Update immediately
                    self.balance = "£" + decoded.card_balance
                    self.invest  = "£" + decoded.investment_balance

                    // Save locally
                    UserDefaults.standard.set(decoded.card_balance, forKey: "card_balance")
                    UserDefaults.standard.set(decoded.investment_balance, forKey: "investment_balance")

                    // UIKit (CardView) – Send update signal
                    NotificationCenter.default.post(name: .didUpdateBalance, object: nil)
                }

            } catch {
                print("Decode error:", error.localizedDescription)
            }

        }.resume()
    }

    // --------------------------------------------------
    // MARK: - Global Refresh
    // --------------------------------------------------
    func refresh() {
        let email = UserDefaults.standard.string(forKey: "email") ?? ""
        if !email.isEmpty {
            getBalance(email: email)
        }
    }
}
