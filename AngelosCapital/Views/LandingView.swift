import SwiftUI

struct LandingView: View {
    @Binding var showSplash: Bool

    @State private var logoOpacity: Double = 0.0
    @State private var glowIntensity: Double = 0.0

    private let fadeDuration: Double = 1.5
    private let totalLoadTime: Double = 4.0

    var body: some View {
        GeometryReader { geometry in
            ZStack {

                // ------------------------------------------------------
                // SYSTEM-ADAPTIVE BACKGROUND
                // Dark mode → black gradient
                // Light mode → soft white gradient
                // ------------------------------------------------------
                RadialGradient(
                    colors: [
                        Color(.systemBackground),
                        Color(.systemBackground).opacity(0.92),
                        Color(.systemBackground)
                    ],
                    center: .center,
                    startRadius: geometry.size.width * 0.4,
                    endRadius: geometry.size.width
                )
                .ignoresSafeArea()

                // ------------------------------------------------------
                // LOGO + GLOW EFFECT (still adaptive)
                // ------------------------------------------------------
                Image("mainw")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .opacity(logoOpacity)
                    .overlay(
                        Circle()
                            .stroke(Color.primary.opacity(glowIntensity * 0.2), lineWidth: 2)
                            .blur(radius: 8)
                    )
                    .shadow(
                        color: Color.primary.opacity(glowIntensity * 0.15),
                        radius: 12
                    )
            }
            .onAppear {
                withAnimation(.easeIn(duration: fadeDuration)) {
                    logoOpacity = 1.0
                    glowIntensity = 1.0
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + totalLoadTime) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        showSplash = false
                    }
                }
            }
        }
    }
}

#Preview {
    LandingView(showSplash: .constant(true))
        .preferredColorScheme(.dark)
}
