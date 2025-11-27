import Foundation

class EmailService {
    static let shared = EmailService()
    private init() {}

    func sendWithdrawalEmail(
        userEmail: String,
        firstName: String,
        amount: String,
        completion: @escaping (Bool, String?) -> Void
    ) {

        guard let url = URL(string: "https://angeloscapital.com/api/send-withdrawal-email") else {
            completion(false, "Bad URL")
            return
        }

        let body: [String: Any] = [
            "user_email": userEmail,
            "first_name": firstName,
            "amount": amount
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }

            guard let http = response as? HTTPURLResponse else {
                completion(false, "No response")
                return
            }

            if http.statusCode == 200 {
                completion(true, nil)
            } else {
                completion(false, "Server responded \(http.statusCode)")
            }

        }.resume()
    }
}
