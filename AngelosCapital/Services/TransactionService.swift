import Foundation
internal import Combine

class TransactionService: ObservableObject {
    static let shared = TransactionService()

    @Published var items: [Transaction] = []

    func loadTransactions() {
        guard let url = URL(string: "https://angeloscapital.com/api/transactions") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else { return }

            if let raw = String(data: data, encoding: .utf8) {
             //   print("Raw transaction JSON:", raw)
            }

            do {
                let decoded = try JSONDecoder().decode(TransactionResponse.self, from: data)

                DispatchQueue.main.async {
                    self.items = decoded.data
                }

            } catch {
              //  print("Decode error:", error)
            }

        }.resume()
    }
}
