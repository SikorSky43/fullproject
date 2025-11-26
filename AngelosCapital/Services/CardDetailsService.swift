import Foundation
internal import Combine

class CardDetailsService: ObservableObject {
    static let shared = CardDetailsService()
    private init() {}

    @Published var card: CardDetail?

    func loadCardDetails(userId: Int) {
        guard let url = URL(string: "https://angeloscapital.com/api/card/user") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["user_id": userId]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, _, error in

            if let error = error {
                print("Network error:", error.localizedDescription)
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            if let raw = String(data: data, encoding: .utf8) {
                print("Card JSON:", raw)
            }

            do {
                // FIX: Decode array instead of single object
                let decoded = try JSONDecoder().decode([CardDetail].self, from: data)

                DispatchQueue.main.async {
                    self.card = decoded.first   // take first card
                }

            } catch {
                print("Decode error:", error.localizedDescription)
            }

        }.resume()
    }
}
