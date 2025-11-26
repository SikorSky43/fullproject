import SwiftUI

struct FloatingAccessory: View {
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "command.square")

            Text(".tabViewBottomAccessory")
                .fontWeight(.semibold)

            Spacer(minLength: 0)

            Image(systemName: "play.fill")
            Image(systemName: "forward.fill")
        }
        .font(.system(size: 15))
        .foregroundColor(.primary)
        .padding(.horizontal, 22)
        .padding(.vertical, 14)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 26, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 26)
                .stroke(Color.white.opacity(0.25), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.15), radius: 14, y: 8)
    }
}
