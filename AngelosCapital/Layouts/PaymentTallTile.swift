import SwiftUI

struct PaymentTallTile: View {

    let dueInDays: Int
    let onPay: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            Text("Payment Due In")
                .font(.headline)
                .foregroundColor(Color.primary.opacity(0.9))   // ADAPTIVE

            Text("\(dueInDays) Days")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(Color.primary)                // ADAPTIVE

            Spacer()

            HStack {
                Spacer()
                Button(action: onPay) {
                    Text("Pay")
                        .font(.headline)
                        .foregroundColor(Color(.systemBackground)) // Text adapts
                        .padding(18)
                        .background(
                            Circle()
                                .fill(Color.primary)              // ADAPTIVE BUTTON
                        )
                }
                Spacer()
            }

        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(.secondarySystemBackground))         // ADAPTIVE TILE
        )
    }
}
