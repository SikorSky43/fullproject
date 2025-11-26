//
//  AuthService.swift
//  Angelos
//

import Foundation
import SwiftUI

final class AuthService {

    static let shared = AuthService()
    private init() {}

    /// Performs network login. On success: saves token/user info to UserDefaults,
    /// updates LogoutService, and replaces root view to RootTabView.
    func login(email: String,
               password: String,
               completion: @escaping (Result<user, Error>) -> Void) {

        guard let url = URL(string: "https://angeloscapital.com/api/login") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = [
            "email": email,
            "password": password
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "Empty data", code: -1)))
                }
                return
            }

            // Debug JSON - keep for troubleshooting
            if let raw = String(data: data, encoding: .utf8) {
                print("LOGIN JSON -->", raw)
            }

            do {
                struct LaravelLoginResponse: Codable {
                    let status: String
                    let token: String
                    let user: user
                }

                let decoded = try JSONDecoder().decode(LaravelLoginResponse.self, from: data)

                // Persist token & user details (consider Keychain for token in the future)
                UserDefaults.standard.set(decoded.token, forKey: "auth_token")
                UserDefaults.standard.set(decoded.user.email, forKey: "email")
                UserDefaults.standard.set(decoded.user.wallet_address, forKey: "wallet_address")
                UserDefaults.standard.set(decoded.user.card_balance, forKey: "card_balance")
                UserDefaults.standard.set(decoded.user.investment_balance, forKey: "investment_balance")
                UserDefaults.standard.set("logged", forKey: "session_active")
                UserDefaults.standard.set(decoded.user.user_id, forKey: "user_id")
                UserDefaults.standard.set(decoded.user.name, forKey: "name")

                DispatchQueue.main.async {
                    // Update LogoutService so UI can observe user
                    LogoutService.shared.login(user: decoded.user)

                    // Switch root to the main tabbed app (single place handling root)
                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let delegate = scene.delegate as? SceneDelegate {
                        delegate.changeRoot(RootTabView())
                    } else {
                        // Fallback: post notification or do nothing (rare)
                        NotificationCenter.default.post(name: .didLogin, object: nil)
                    }

                    completion(.success(decoded.user))
                }

            } catch {
                DispatchQueue.main.async {
                    print("JSON decode error:", error.localizedDescription)
                    completion(.failure(error))
                }
            }

        }.resume()
    }

    /// Full local logout. Clears persisted session & biometric preference and resets root.
    func logout(completion: (() -> Void)? = nil) {
        let keysToRemove = [
            "auth_token",
            "email",
            "wallet_address",
            "card_balance",
            "investment_balance",
            "session_active",
            "user_id",
            "name"
        ]

        for key in keysToRemove {
            UserDefaults.standard.removeObject(forKey: key)
        }

        // Disable persisted biometric preference
      //  BiometricAuth.shared.biometricEnabled = false

        // Update in-memory logout state
        DispatchQueue.main.async {
            LogoutService.shared.logout()
            NotificationCenter.default.post(name: .didLogout, object: nil)
            // Replace root to LoginView
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let delegate = scene.delegate as? SceneDelegate {
                delegate.changeRoot(LoginView())
            }
            completion?()
        }
    }
}

extension Notification.Name {
    static let didLogin = Notification.Name("didLoginNotification")
}
