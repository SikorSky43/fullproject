import SwiftUI

struct GlassCard: View {
    @Binding var focalPointOffset: CGPoint

    var body: some View {
        ZStack {
            // Your animated UIKit card inside SwiftUI
            CardViewRepresentable(focalPointOffset: $focalPointOffset)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .frame(height: 230)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
                .opacity(0.4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.25), lineWidth: 1.4)
        )
        .shadow(color: .white.opacity(0.08), radius: 16, x: 0, y: 6)
        .padding(.horizontal, 20)
    }
}
