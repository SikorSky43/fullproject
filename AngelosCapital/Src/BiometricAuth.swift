//
//  BiometricAuth.swift
//  Angelos
//

import Foundation
import LocalAuthentication
internal import Combine
import SwiftUI

final class BiometricAuth: ObservableObject {

    static let shared = BiometricAuth()

    let objectWillChange = ObservableObjectPublisher()

    @Published var biometricEnabled: Bool = UserDefaults.standard.bool(forKey: "biometric_enabled") {
        didSet {
            UserDefaults.standard.set(biometricEnabled, forKey: "biometric_enabled")
        }
    }

    private init() {
        self.biometricEnabled = UserDefaults.standard.bool(forKey: "biometric_enabled")
    }

    // MARK: - Check availability
    var canUseBiometrics: Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }

    // MARK: - Authentication
    func authenticate(localizedReason: String = "Unlock Angelos", completion: @escaping (Bool) -> Void) {

        let context = LAContext()
        context.localizedFallbackTitle = ""

        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        else {
            DispatchQueue.main.async { completion(false) }
            return
        }

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: localizedReason) { success, _ in

            DispatchQueue.main.async {
                // Only succeed if token exists and session is logged
                if success,
                   UserDefaults.standard.string(forKey: "auth_token") != nil,
                   UserDefaults.standard.string(forKey: "session_active") == "logged" {

                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
}
