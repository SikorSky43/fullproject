import SwiftUI
import UIKit

struct CardViewRepresentable: UIViewRepresentable {
    @Binding var focalPointOffset: CGPoint

    func makeUIView(context: Context) -> CardView {
        let view = CardView()
        view.backgroundColor = .black
        return view
    }

    func updateUIView(_ uiView: CardView, context: Context) {
        DispatchQueue.main.async {
            // Update the origin focal point based on final SwiftUI size
            uiView.originFocalPoint = CGPoint(
                x: uiView.bounds.width / 2,
                y: uiView.bounds.height
            )

            // If dots haven't been set up yet, set them up NOW after SwiftUI sets frame
            if uiView.subviews.count < 5 {
                uiView.setupDots()
            }

            // Apply dynamic color update
            let base = uiView.originFocalPoint
            let offset = focalPointOffset

            uiView.updateColors(
                withFocalPoint: CGPoint(
                    x: base.x + offset.x,
                    y: base.y + offset.y
                )
            )
        }
    }
}
