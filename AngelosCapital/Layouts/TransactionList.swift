import SwiftUI

struct TransactionList: View {
    @ObservedObject var transactionService = TransactionService.shared

    // Use API data instead of HistoryComp
    var visibleTransactions: [Transaction] {
        transactionService.items
    }

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Transactions
            ForEach(visibleTransactions) { item in
                HStack(spacing: 14) {

                    // Asset Image
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 52, height: 52)
                        .overlay(
                            AsyncImage(url: URL(string: item.asset)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView().tint(.white)
                                case .success(let image):
                                    image.resizable().scaledToFit()
                                case .failure(_):
                                    Image(systemName: "photo").foregroundColor(.gray)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .padding(6)
                        )

                    // Text Info
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.type.capitalized)
                            .foregroundColor(.white)
                            .font(.headline)

                        Text(formatDisplayDate(item.date))
                            .foregroundColor(.gray)
                            .font(.caption)
                    }

                    Spacer()

                    // Amount
                    Text(item.amount)
                        .foregroundColor(.white)
                        .font(.headline)
                }
                .padding(16)

                Divider().padding(.leading, 66)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color(red: 0.11, green: 0.11, blue: 0.12))
        )
    }

    // MARK: - Format "2025-11-24 12:32:55"
    func formatDisplayDate(_ ts: String) -> String {
        let parts = ts.split(separator: " ")
        if parts.count == 2 {
            return "\(parts[0]) • \(parts[1])"
        }
        return ts
    }
}
