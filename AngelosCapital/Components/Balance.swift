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

    @Published var balance: String = "£0.00"   // Display card balance
    @Published var invest: String  = "£0.00"   // Display investment balance

    private let endpoint = "https://angeloscapital.com/api/balance"

    // --------------------------------------------------
    // MARK: - Main API Call
    // --------------------------------------------------
    func getBalance(email: String) {

        guard let url = URL(string: endpoint) else {
            print("❌ BalanceService — Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["email": email]
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, response, error in

            // Basic network safety
            if let error = error {
                print("❌ BalanceService — Network error:", error.localizedDescription)
                return
            }

            guard let data = data else {
                print("❌ BalanceService — Empty response data")
                return
            }

            struct BalanceResponse: Codable {
                let status: String
                let card_balance: String
                let investment_balance: String
            }

            do {
                let decoded = try JSONDecoder().decode(BalanceResponse.self, from: data)

                DispatchQueue.main.async {

                    // Force formatting (avoid server invalid formats)
                    let card = decoded.card_balance.trimmingCharacters(in: .whitespacesAndNewlines)
                    let invest = decoded.investment_balance.trimmingCharacters(in: .whitespacesAndNewlines)

                    // SwiftUI observable updates
                    self.balance = "£" + card
                    self.invest  = "£" + invest

                    // Save locally for offline usage
                    UserDefaults.standard.set(card,   forKey: "card_balance")
                    UserDefaults.standard.set(invest, forKey: "investment_balance")

                    // UIKit CardView update
                    NotificationCenter.default.post(name: .didUpdateBalance, object: nil)
                }

            } catch {
                print("❌ BalanceService — JSON decode error:", error.localizedDescription)
                print("⚠️ Raw Server Response:", String(data: data, encoding: .utf8) ?? "nil")
            }

        }.resume()
    }

    // --------------------------------------------------
    // MARK: - Global Refresh
    // --------------------------------------------------
    func refresh() {
        let email = UserDefaults.standard.string(forKey: "email") ?? ""
        guard !email.isEmpty else { return }
        getBalance(email: email)
    }
}
