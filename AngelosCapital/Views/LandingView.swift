import SwiftUI

struct LandingView: View {
    @Binding var showSplash: Bool   // ← Add this!

    @State private var logoOpacity: Double = 0.0
    @State private var glowIntensity: Double = 0.0

    private let fadeDuration: Double = 1.5
    private let totalLoadTime: Double = 4.0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RadialGradient(
                    colors: [.black, .black.opacity(0.95), .black],
                    center: .center,
                    startRadius: geometry.size.width * 0.4,
                    endRadius: geometry.size.width
                )
                .ignoresSafeArea()

                Image("mainw")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .opacity(logoOpacity)
                    .overlay(
                        Circle()
                            .stroke(.white.opacity(glowIntensity * 0.2), lineWidth: 2)
                            .blur(radius: 8)
                    )
                    .shadow(color: .white.opacity(glowIntensity * 0.1), radius: 12)
            }
            .onAppear {
                withAnimation(.easeIn(duration: fadeDuration)) {
                    logoOpacity = 1.0
                    glowIntensity = 1.0
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + totalLoadTime) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        showSplash = false   // ← Tell app to move forward
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
