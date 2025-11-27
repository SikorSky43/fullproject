import SwiftUI

struct BalanceTile: View {
    @ObservedObject private var balanceService = Balance.shared

    var body: some View {
        VStack {
            Text("Total Balance")
                .font(.headline)
                .foregroundColor(.white.opacity(0.95))
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer(minLength: 0)

            Text(balanceService.balance)   // ← LIVE VALUE
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .minimumScaleFactor(0.8)

            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(red: 0.11, green: 0.11, blue: 0.12))
        )
    }
}
