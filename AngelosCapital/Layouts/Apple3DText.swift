import SwiftUI

struct Apple3DText: View {
    var text: String
    var size: CGFloat

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ZStack {

            // -------------------------------------------------------
            // SHADOW LAYER (deepest layer)
            // Dark mode: soft white shadow
            // Light mode: soft black shadow
            // -------------------------------------------------------
            Text(text)
                .font(.system(size: size, weight: .bold, design: .rounded))
                .foregroundColor(
                    scheme == .dark
                    ? Color.white.opacity(0.18)
                    : Color.black.opacity(0.18)
                )
                .offset(x: 3, y: 3)

            // -------------------------------------------------------
            // MID-LAYER (inner bevel glow)
            // -------------------------------------------------------
            Text(text)
                .font(.system(size: size, weight: .bold, design: .rounded))
                .foregroundColor(
                    scheme == .dark
                    ? Color.white.opacity(0.45)
                    : Color.black.opacity(0.30)   // softer in light mode
                )
                .offset(x: 1.7, y: 1.7)

            // -------------------------------------------------------
            // TOP LAYER (true color)
            // -------------------------------------------------------
            Text(text)
                .font(.system(size: size, weight: .bold, design: .rounded))
                .foregroundColor(
                    scheme == .dark
                    ? Color.white
                    : Color.primary                 // black in light, white in dark
                )
        }
    }
}
