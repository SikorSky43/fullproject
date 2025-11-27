//
//  LoginView.swift
//

import SwiftUI

struct LoginView: View {

    @StateObject private var vm = LoginService.shared
    @State private var showForgotPassword = false
    @StateObject private var bioAuth = BiometricAuth.shared

    var body: some View {
        NavigationStack {
            ZStack {

                // ADAPTIVE BACKGROUND (MAIN FIX)
                Color(.systemBackground)
                    .ignoresSafeArea()

                VStack(spacing: 32) {
                    Spacer()

                    VStack(spacing: 6) {
                        Text("Sign in with your account to access\nAngelos services.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.secondary)    // adaptive
                            .font(.callout)
                    }

                    VStack(spacing: 16) {

                        // EMAIL FIELD
                        TextField("Email", text: $vm.email)
                            .textInputAutocapitalization(.never)
                            .padding()
                            .background(Color.secondary.opacity(0.12))  // adaptive
                            .foregroundColor(Color.primary)              // adaptive
                            .cornerRadius(12)

                        // PASSWORD FIELD
                        SecureField("Password", text: $vm.password)
                            .padding()
                            .background(Color.secondary.opacity(0.12))   // adaptive
                            .foregroundColor(Color.primary)               // adaptive
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 28)

                    Button {
                        showForgotPassword = true
                    } label: {
                        Text("Forgot password?")
                            .foregroundColor(.blue)   // OK, blue works in both
                            .font(.callout)
                    }

                    // LOGIN BUTTON (glass)
                    liquidGlassButton

                    // FACE ID LOGIN BUTTON
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
                            .foregroundColor(.blue)   // OK traditional Apple style
                            .padding(.top, 10)
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal, 28)
            }

            // ALERTS
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

            // FACE ID AUTO LOGIN
            .onAppear {
                if bioAuth.biometricEnabled && bioAuth.canUseBiometrics &&
                    UserDefaults.standard.string(forKey: "auth_token") != nil &&
                    UserDefaults.standard.string(forKey: "session_active") == "logged" {

                    bioAuth.authenticate { success in
                        if success { vm.quickLogin() }
                    }
                }
            }
        }
    }

    // MARK: - Adaptive Liquid Glass Button
    private var liquidGlassButton: some View {
        Button {
            vm.login()
        } label: {
            HStack {
                if vm.isLoading {
                    ProgressView()
                        .progressViewStyle(
                            CircularProgressViewStyle(tint: Color.primary) // adaptive
                        )
                        .padding(.trailing, 8)
                }

                Text(vm.isLoading ? "Logging in..." : "Continue")
                    .font(.headline.bold())
                    .foregroundColor(Color.primary)  // adaptive
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                // ultra thin glass automatically adapts to Light/Dark
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.primary.opacity(0.25), lineWidth: 1) // adaptive stroke
                    )
                    .shadow(color: Color.primary.opacity(0.10), radius: 12, x: 0, y: 8)
            )
        }
        .padding(.horizontal, 28)
        .disabled(vm.isLoading)
    }
}
