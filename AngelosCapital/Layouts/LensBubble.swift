import SwiftUI

struct LensBubble: View {
    let icon: String
    let title: String
    let show: Bool

    var body: some View {
        if show {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.blue)
                    .shadow(radius: 4)

                Text(title)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            .padding(18)
            .background(
                .ultraThinMaterial,
                in: Circle()
            )
            .overlay(
                Circle().stroke(Color.white.opacity(0.25), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
            .transition(.scale.combined(with: .opacity))
        }
    }
}
