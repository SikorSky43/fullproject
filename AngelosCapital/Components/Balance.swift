import Foundation
internal import Combine

class Balance: ObservableObject {
    static let shared = Balance()
    private init() {}

    @Published var balance: String = "£0.00"

    func getBalance(email: String) {
        guard let url = URL(string: "https://angeloscapital.com/api/balance") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["email": email]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }

            if let raw = String(data: data, encoding: .utf8) {
               // print("Balance JSON:", raw)
            }

            struct BalanceResponse: Codable {
                let status: String
                let card_balance: String
                let investment_balance: String
            }

            do {
                let decoded = try JSONDecoder().decode(BalanceResponse.self, from: data)
                DispatchQueue.main.async {
                    self.balance = "£" + decoded.card_balance
                    UserDefaults.standard.set(decoded.investment_balance, forKey: "investment_balance")
                }
            } catch {
              //  print("Decode error:", error)
            }
        }
        .resume()
    }

}
