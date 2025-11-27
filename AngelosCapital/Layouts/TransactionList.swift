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

                    // Asset Image Container (adaptive)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.secondary.opacity(0.12))
                        .frame(width: 52, height: 52)
                        .overlay(
                            AsyncImage(url: URL(string: item.asset)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .tint(Color.primary)  // adaptive
                                case .success(let image):
                                    image.resizable().scaledToFit()
                                case .failure(_):
                                    Image(systemName: "photo")
                                        .foregroundColor(Color.secondary)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .padding(6)
                        )

                    // Text Info
                    VStack(alignment: .leading, spacing: 4) {

                        Text(item.type.capitalized)
                            .foregroundColor(Color.primary)  // adaptive
                            .font(.headline)

                        Text(formatDisplayDate(item.date))
                            .foregroundColor(Color.secondary) // adaptive
                            .font(.caption)
                    }

                    Spacer()

                    // Amount
                    Text(item.amount)
                        .foregroundColor(Color.primary)  // adaptive
                        .font(.headline)
                }
                .padding(16)

                Divider().padding(.leading, 66)
            }
        }
        .background(
            // Adaptive tile background (NOT hard-black)
            RoundedRectangle(cornerRadius: 22)
                .fill(Color(.secondarySystemBackground))
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
