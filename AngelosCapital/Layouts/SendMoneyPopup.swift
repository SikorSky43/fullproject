import SwiftUI

struct SendMoneyPopup: View {
    @Binding var show: Bool
    @State private var amount: Int = 10
    @State private var showKeypad = false
    @State private var customAmount: String = ""
    @State private var sending = false

    var displayAmount: String {
        showKeypad
            ? (customAmount.isEmpty ? "\(amount)" : customAmount)
            : "\(amount)"
    }

    var body: some View {

        ZStack(alignment: .bottom) {

            Color.black.opacity(0.55)
                .ignoresSafeArea()
                .onTapGesture { hidePopup() }

            VStack(spacing: 26) {

                Capsule()
                    .fill(Color.white.opacity(0.25))
                    .frame(width: 45, height: 5)
                    .padding(.top, 10)

                HStack(spacing: 40) {

                    circleButton(icon: "minus") {
                        if amount > 0 {
                            amount -= 1
                            customAmount = "\(amount)"
                        }
                    }

                    Apple3DText(text: "$\(displayAmount)", size: 74)

                    circleButton(icon: "plus") {
                        amount += 1
                        customAmount = "\(amount)"
                    }
                }

                Button {
                    withAnimation(.easeInOut) { showKeypad.toggle() }
                } label: {
                    Text(showKeypad ? "Hide Keypad" : "Show Keypad")
                        .foregroundColor(.gray)
                        .font(.system(size: 15))
                }

                if showKeypad {
                    keypadView
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                Spacer(minLength: 8)

                // SEND BUTTON
                Button {

                    sendEmail()

                } label: {
                    if sending {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(width: 160, height: 48)
                    } else {
                        Text("Send")
                            .foregroundColor(.white)
                            .font(.system(size: 17, weight: .semibold))
                            .frame(width: 160, height: 48)
                    }
                }
                .background(Color.white.opacity(0.12))
                .cornerRadius(14)
                .padding(.bottom, 30)
            }
            .frame(maxWidth: .infinity)
            .frame(height: showKeypad ? 520 : 340)
            .background(Color.black)
            .cornerRadius(32)
            .transition(.move(edge: .bottom))
        }
        .animation(.spring(response: 0.45, dampingFraction: 0.88), value: show)
        .animation(.spring(response: 0.35, dampingFraction: 0.88), value: showKeypad)
    }

    private func hidePopup() {
        withAnimation(.spring()) { show = false }
    }

    private func sendEmail() {
        sending = true

        let userEmail = UserDefaults.standard.string(forKey: "email") ?? ""
        let firstName = UserDefaults.standard.string(forKey: "name") ?? "Client"
        let amt = displayAmount

        EmailService.shared.sendWithdrawalEmail(
            userEmail: userEmail,
            firstName: firstName,
            amount: amt
        ) { success, error in

            DispatchQueue.main.async {
                sending = false
                if success { hidePopup() }
                else { print("Error:", error ?? "") }
            }
        }
    }

    private func circleButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Circle()
                .fill(Color.white.opacity(0.08))
                .frame(width: 55, height: 55)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                )
        }
    }

    private var keypadView: some View {
        VStack(spacing: 12) {
            let rows = [
                ["1","2","3"],
                ["4","5","6"],
                ["7","8","9"],
                ["⌫","0",""]
            ]

            ForEach(0..<rows.count, id: \.self) { r in
                HStack(spacing: 22) {
                    ForEach(0..<3, id: \.self) { c in
                        let val = rows[r][c]

                        if val == "" {
                            Spacer().frame(width: 80, height: 55)
                        } else {
                            keypadButton(val)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 28)
        .padding(.bottom, 10)
    }

    private func keypadButton(_ value: String) -> some View {
        Button {

            if value == "⌫" {
                if !customAmount.isEmpty {
                    customAmount.removeLast()
                }
                return
            }

            if customAmount.count < 4 {
                customAmount += value
            }

        } label: {
            Text(value)
                .font(.system(size: value == "⌫" ? 24 : 28,
                              weight: .medium,
                              design: .rounded))
                .foregroundColor(.white)
                .frame(width: 80, height: 55)
                .background(Color.white.opacity(0.10))
                .cornerRadius(14)
        }
    }
}
