import SwiftUI

struct PaymentTallTile: View {

    let dueInDays: Int
    let onPay: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            Text("Payment Due In")
                .font(.headline)
                .foregroundColor(.white.opacity(0.9))

            Text("\(dueInDays) Days")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)

            Spacer()

            HStack {
                Spacer()
                Button(action: onPay) {
                    Text("Pay")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(18)
                        .background(Color.white)
                        .clipShape(Circle())
                }
                Spacer()
            }

        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(red: 0.11, green: 0.11, blue: 0.12))
        )
    }
}
