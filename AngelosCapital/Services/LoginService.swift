//
//  LoginService.swift
//

import Foundation
import SwiftUI
internal import Combine

class LoginService: ObservableObject {

    // Singleton so other parts of the app can reference the same instance
    static let shared = LoginService()
    private init() {}

    @Published var email: String = ""
    @Published var password: String = ""

    @Published var isLoading = false
    @Published var isLoggedIn = false
    @Published var showMessage = false
    @Published var messageText = ""

    func logout() {
        isLoggedIn = false
        UserDefaults.standard.removeObject(forKey: "auth_token")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "wallet_address")
        UserDefaults.standard.removeObject(forKey: "card_balance")
        UserDefaults.standard.removeObject(forKey: "investment_balance")
    }

    func login() {

        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedEmail.isEmpty, !trimmedPassword.isEmpty else {
            messageText = "Please enter email and password."
            showMessage = true
            return
        }

        isLoading = true

        AuthService.shared.login(email: trimmedEmail, password: trimmedPassword) { result in
            DispatchQueue.main.async {
                self.isLoading = false

                switch result {
                case .success(let user):
                    // LogoutService updated inside AuthService; set local flag just for view state if needed
                    self.isLoggedIn = true
                case .failure(let error):
                    self.messageText = "Login failed: \(error.localizedDescription)"
                    self.showMessage = true
                }
            }
        }
    }

    func sendForgotPasswordEmail() {
        let email = "Helpme@angeloscapital.com"
        let subject = "Password Reset Request"
        let body = "Hello,\n\nI need help resetting my password."

        let encoded = "mailto:\(email)?subject=\(subject)&body=\(body)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        if let url = URL(string: encoded) {
            UIApplication.shared.open(url)
        }
    }

    // Called after biometric success to mark local flag (AuthService will have already stored token earlier)
    func quickLogin() {
        // When biometric succeeds, AuthService previously stored token in UserDefaults.
        // We can emulate a successful login by reading user data and setting LogoutService.
        if let email = UserDefaults.standard.string(forKey: "email") {
            let restoredUser = user(
                user_id: UserDefaults.standard.integer(forKey: "user_id"),
                name: UserDefaults.standard.string(forKey: "name"),
                email: email,
                wallet_address: UserDefaults.standard.string(forKey: "wallet_address"),
                card_balance: UserDefaults.standard.string(forKey: "card_balance") ?? "0",
                investment_balance: UserDefaults.standard.string(forKey: "investment_balance") ?? "0"
            )
            LogoutService.shared.login(user: restoredUser)

            // Switch root immediately
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let delegate = scene.delegate as? SceneDelegate {
                delegate.changeRoot(RootTabView())
            }

            self.isLoggedIn = true
        } else {
            // No stored email/token: require full login
            messageText = "No saved session; please log in normally."
            showMessage = true
        }
    }
}
