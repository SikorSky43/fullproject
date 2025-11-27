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
                    .shadow(color: Color.primary.opacity(0.25), radius: 4)   // ADAPTIVE

                Text(title)
                    .font(.caption)
                    .foregroundColor(.primary)                             // ADAPTIVE
            }
            .padding(18)
            .background(
                .ultraThinMaterial,
                in: Circle()
            )
            .overlay(
                Circle()
                    .stroke(Color.primary.opacity(0.25), lineWidth: 1)    // ADAPTIVE OUTLINE
            )
            .shadow(
                color: Color.primary.opacity(0.15),                      // ADAPTIVE SHADOW
                radius: 8, y: 4
            )
            .transition(.scale.combined(with: .opacity))
        }
    }
}
