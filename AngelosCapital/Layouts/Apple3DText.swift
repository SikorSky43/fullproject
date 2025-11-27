import SwiftUI

struct Apple3DText: View {
    var text: String
    var size: CGFloat

    var body: some View {
        ZStack {
            Text(text)
                .font(.system(size: size, weight: .bold, design: .rounded))
                .foregroundColor(Color.white.opacity(0.18))
                .offset(x: 3, y: 3)

            Text(text)
                .font(.system(size: size, weight: .bold, design: .rounded))
                .foregroundColor(Color.white.opacity(0.45))
                .offset(x: 1.7, y: 1.7)

            Text(text)
                .font(.system(size: size, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
    }
}
