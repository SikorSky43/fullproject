import SwiftUI

struct BalanceTile: View {
    @ObservedObject private var balanceService = Balance.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            Text("Total Balance")
                .font(.headline)
                .foregroundColor(Color.primary.opacity(0.9))     // ADAPTIVE
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer(minLength: 0)

            Text(balanceService.balance)                         // LIVE VALUE
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(Color.primary)                  // ADAPTIVE
                .minimumScaleFactor(0.8)

            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(.secondarySystemBackground))         // ADAPTIVE TILE
        )
    }
}
