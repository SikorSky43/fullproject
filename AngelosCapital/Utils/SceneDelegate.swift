//
//  SceneDelegate.swift
//  Angelos
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)

        // Try to restore session
        let isLogged = UserDefaults.standard.string(forKey: "session_active") == "logged"
        let token = UserDefaults.standard.string(forKey: "auth_token")

        if isLogged, token != nil {
            window.rootViewController = UIHostingController(rootView: RootTab())
        } else {
            window.rootViewController = UIHostingController(rootView: LoginView())
        }

        self.window = window
        window.makeKeyAndVisible()
    }

    // Helper for replacing the root view from anywhere
    func changeRoot<Content: View>(_ view: Content, animated: Bool = true) {
        guard let window = self.window else { return }
        let host = UIHostingController(rootView: view)
        if animated {
            UIView.transition(with: window, duration: 0.35, options: [.transitionCrossDissolve], animations: {
                window.rootViewController = host
            }, completion: nil)
        } else {
            window.rootViewController = host
        }
        window.makeKeyAndVisible()
    }
}
