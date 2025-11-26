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
            Color.black.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {

                // Close button with Liquid Glass
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
                                    .foregroundColor(.white)
                            )
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)

                Text("Deposit")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal)

                // Dropdown with no icons
                VStack(alignment: .leading, spacing: 12) {
                    Text("Select Coin")
                        .foregroundColor(.gray)

                    Menu {
                        ForEach(coins, id: \.self) { coin in
                            Button {
                                selectedCoin = coin
                            } label: {
                                Text(coin)
                                    .foregroundColor(.white)
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedCoin)
                                .foregroundColor(.white)

                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(14)
                    }
                }
                .padding(.horizontal)

                // Network field
                VStack(alignment: .leading, spacing: 6) {
                    Text("Network")
                        .foregroundColor(.gray)

                    Text(network)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(14)
                }
                .padding(.horizontal)

                // Wallet Address
                VStack(alignment: .leading, spacing: 6) {
                    Text("\(selectedCoin) Wallet Address")
                        .foregroundColor(.gray)

                    HStack {
                        Text(generatedAddress)
                            .foregroundColor(.white)
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
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.15))
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
                        .background(Color.white.opacity(0.15))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.bottom, 40)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}
