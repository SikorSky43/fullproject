//
//  LogoutService.swift
//

import Foundation
internal import Combine

class LogoutService: ObservableObject {
    static let shared = LogoutService()
    private init() {}

    @Published var isLoggedIn = false
    @Published var currentUser: user? = nil

    func login(user: user) {
        currentUser = user
        isLoggedIn = true
    }

    /// Log out locally without touching server (UI-friendly).
    /// This only updates local app state — clearing persisted session is handled by AuthService.
    func logout() {
        currentUser = nil
        isLoggedIn = false

        // Post a notification so views can observe and react immediately if needed
        NotificationCenter.default.post(name: .didLogout, object: nil)
    }
}

extension Notification.Name {
    static let didLogout = Notification.Name("didLogoutNotification")
}
