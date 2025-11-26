import SwiftUI

struct CardDetails: View {
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var cardNumber: String = ""
    @State private var expiry: String = ""
    @State private var cvv: String = ""
    @State private var description: String = ""

    @StateObject private var cardService = CardDetailsService.shared
    @State private var copiedToast = false

    var body: some View {
        ZStack {

            // ===========================
            // MAIN CONTENT (CENTERED)
            // ===========================
            VStack(spacing: 24) {

                Text("Card Details")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(.white)

                Text("Your saved card information")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))

                CardInfoTile
                    .frame(maxWidth: 400)
                    .padding(.horizontal, 24)

                Spacer()
            }
            .padding(.top, 100)
            .padding(.bottom, 80)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

            // ===========================
            // CLOSE BUTTON
            // ===========================
            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(.clear)
                            .frame(width: 42, height: 42)
                            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 18))
                            .overlay(
                                Image(systemName: "xmark")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.95))
                            )
                    }
                    .padding(.leading, 16)
                    Spacer()
                }
                Spacer()
            }

            // ===========================
            // COPY TOAST
            // ===========================
            if copiedToast {
                VStack {
                    Spacer()
                    Text("Copied!")
                        .font(.system(size: 16, weight: .medium))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.15))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.bottom, 40)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            let userId = UserDefaults.standard.integer(forKey: "user_id")
            cardService.loadCardDetails(userId: userId)
            print("DEBUG — user_id in UserDefaults =", userId)

        }
        .onReceive(cardService.$card) { card in
            guard let c = card else { return }

            self.name = "My Card"
            self.cardNumber = c.card_number
            self.expiry = "\(c.expiry_month)/\(String(c.expiry_year).suffix(2))"
            self.cvv = c.cvv
            self.description = ""
        }
    }

    // MARK: - TILE
    var CardInfoTile: some View {
        VStack(spacing: 0) {

            TileRow(title: "Name", value: name) { copy(name) }
            DividerLine()

            TileRow(title: "Card Number", value: cardNumber) { copy(cardNumber) }
            DividerLine()

            TileRow(title: "Expiry Date", value: expiry) { copy(expiry) }
            DividerLine()

            TileRow(title: "Security Code", value: cvv) { copy(cvv) }
            DividerLine()

            TileRow(title: "Description", value: description) { copy(description) }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 28/255, green: 28/255, blue: 30/255))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                )
        )
    }

    // MARK: - COPY HANDLER
    func copy(_ text: String) {
        guard !text.isEmpty else { return }
        UIPasteboard.general.string = text

        withAnimation { copiedToast = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation { copiedToast = false }
        }
    }
}

// MARK: - COMPONENTS

struct TileRow: View {
    let title: String
    let value: String
    let copyAction: () -> Void

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.white.opacity(0.85))
                .font(.system(size: 16))

            Spacer()

            Text(value.isEmpty ? "-" : value)
                .foregroundColor(.white.opacity(0.9))
                .font(.system(size: 16))
                .lineLimit(1)

            Button(action: copyAction) {
                Image(systemName: "doc.on.doc")
                    .foregroundColor(.white.opacity(0.85))
                    .font(.system(size: 15))
            }
            .padding(.leading, 6)
        }
        .padding(.vertical, 14)
    }
}

struct DividerLine: View {
    var body: some View {
        Divider()
            .background(Color.white.opacity(0.08))
    }
}
