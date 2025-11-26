//
//  LoginView.swift
//

import SwiftUI

struct LoginView: View {

    // Use the shared singleton instance so the same state is observed everywhere
    @StateObject private var vm = LoginService.shared
    @State private var showForgotPassword = false
    @StateObject private var bioAuth = BiometricAuth.shared

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 32) {
                    Spacer()

                    VStack(spacing: 6) {
                        Text("Sign in with your account to access\nAngelos services.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .font(.callout)
                    }

                    VStack(spacing: 16) {
                        TextField("Email", text: $vm.email)
                            .textInputAutocapitalization(.never)
                            .padding()
                            .background(Color.white.opacity(0.08))
                            .foregroundColor(.white)
                            .cornerRadius(12)

                        SecureField("Password", text: $vm.password)
                            .padding()
                            .background(Color.white.opacity(0.08))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 28)

                    Button {
                        showForgotPassword = true
                    } label: {
                        Text("Forgot password?")
                            .foregroundColor(.blue)
                            .font(.callout)
                    }

                    // MAIN LOGIN BUTTON
                    liquidGlassButton

                    // FACE ID LOGIN BUTTON (only shows when enabled and available)
                    if bioAuth.biometricEnabled && bioAuth.canUseBiometrics {
                        Button {
                            bioAuth.authenticate { success in
                                if success {
                                    vm.quickLogin()
                                } else {
                                    vm.messageText = "Face ID failed."
                                    vm.showMessage = true
                                }
                            }
                        } label: {
                            HStack {
                                Image(systemName: "faceid")
                                Text("Login with Face ID")
                            }
                            .foregroundColor(.blue)
                            .padding(.top, 10)
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal, 28)
            }
            .alert("Login Status", isPresented: $vm.showMessage) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(vm.messageText)
            }
            .alert("Reset Your Password", isPresented: $showForgotPassword) {
                Button("Send Email") {
                    vm.sendForgotPasswordEmail()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("To reset your password, send an email to:\nHelpme@angeloscapital.com")
            }
            .onAppear {
                // Auto-trigger Face ID only when biometric preference is on and there is a stored token/session
                if bioAuth.biometricEnabled && bioAuth.canUseBiometrics &&
                    UserDefaults.standard.string(forKey: "auth_token") != nil &&
                    UserDefaults.standard.string(forKey: "session_active") == "logged" {

                    bioAuth.authenticate { success in
                        if success {
                            vm.quickLogin()
                        }
                    }
                }
            }
        }
    }

    // MARK: - Main Login Button
    private var liquidGlassButton: some View {
        Button {
            vm.login()
        } label: {
            HStack {
                if vm.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding(.trailing, 8)
                }
                Text(vm.isLoading ? "Logging in..." : "Continue")
                    .font(.headline.bold())
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.25), lineWidth: 1)
                    )
                    .shadow(color: Color.white.opacity(0.12), radius: 12, x: 0, y: 8)
            )
        }
        .padding(.horizontal, 28)
        .disabled(vm.isLoading)
    }
}
