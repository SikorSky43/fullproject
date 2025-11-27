import SwiftUI

struct DepositPopup: View {
    @Binding var showDepositPopup: Bool
    @State private var selectedCoin = "USDT"
    @State private var copiedToast = false

    private let coins = ["USDT", "BTC", "ETH"]

    var generatedAddress: String {
        switch selectedCoin {
        case "BTC":
            return "bc1q" + UUID().uuidString.prefix(30)
        case "ETH":
            return "0x" + UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(38)
        default:
            return "0x" + UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(38)
        }
    }

    var network: String {
        switch selectedCoin {
        case "BTC": return "BTC Network"
        case "ETH": return "ERC20"
        default: return "ERC20"
        }
    }

    var body: some View {
        ZStack {

            // ADAPTIVE BACKGROUND
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {

                // Close button
                HStack {
                    Button {
                        showDepositPopup = false
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.clear)
                            .frame(width: 42, height: 42)
                            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20))
                            .overlay(
                                Image(systemName: "xmark")
                                    .font(.title3.bold())
                                    .foregroundColor(Color.primary)   // ADAPTIVE
                            )
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)

                Text("Deposit")
                    .font(.largeTitle.bold())
                    .foregroundColor(Color.primary)         // ADAPTIVE
                    .padding(.horizontal)

                // Dropdown
                VStack(alignment: .leading, spacing: 12) {
                    Text("Select Coin")
                        .foregroundColor(Color.secondary)

                    Menu {
                        ForEach(coins, id: \.self) { coin in
                            Button {
                                selectedCoin = coin
                            } label: {
                                Text(coin)
                                    .foregroundColor(Color.primary)
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedCoin)
                                .foregroundColor(Color.primary)

                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(Color.secondary)
                        }
                        .padding()
                        .background(Color.secondary.opacity(0.15))   // ADAPTIVE
                        .cornerRadius(14)
                    }
                }
                .padding(.horizontal)

                // Network
                VStack(alignment: .leading, spacing: 6) {
                    Text("Network")
                        .foregroundColor(Color.secondary)

                    Text(network)
                        .foregroundColor(Color.primary)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.secondary.opacity(0.15))   // ADAPTIVE
                        .cornerRadius(14)
                }
                .padding(.horizontal)

                // Wallet Address
                VStack(alignment: .leading, spacing: 6) {
                    Text("\(selectedCoin) Wallet Address")
                        .foregroundColor(Color.secondary)

                    HStack {
                        Text(generatedAddress)
                            .foregroundColor(Color.primary)
                            .font(.system(size: 14, weight: .medium))
                            .lineLimit(1)

                        Spacer()

                        Button {
                            UIPasteboard.general.string = generatedAddress
                            withAnimation { copiedToast = true }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                                withAnimation { copiedToast = false }
                            }
                        } label: {
                            Image(systemName: "doc.on.doc")
                                .foregroundColor(Color.primary)
                        }
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.15))       // ADAPTIVE
                    .cornerRadius(14)
                }
                .padding(.horizontal)

                Spacer()
            }

            // Copy toast
            if copiedToast {
                VStack {
                    Spacer()
                    Text("Copied!")
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.secondary.opacity(0.2))      // ADAPTIVE
                        )
                        .foregroundColor(Color.primary)
                        .padding(.bottom, 40)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}
