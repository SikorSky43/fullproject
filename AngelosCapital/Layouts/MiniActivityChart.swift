import Foundation
import SwiftUI

struct MiniActivityChart: View {
    let values: [Double]

    // Normalize values for equal scale
    private var normalized: [Double] {
        let maxVal = values.max() ?? 1
        return values.map { max(0.05, $0 / maxVal) }
    }

    private let gradient = LinearGradient(
        colors: [.orange, .yellow, .green, .cyan, .blue, .purple],
        startPoint: .bottom,
        endPoint: .top
    )

    var body: some View {
        GeometryReader { geo in
            let count = CGFloat(values.count)

            // *** tighter bar width and spacing ***
            let barWidth = (geo.size.width / count) * 0.45
            let spacing = (geo.size.width - (barWidth * count)) / (count - 1)

            // *** NEW LOWER HEIGHT FACTOR (Apple style) ***
            let barHeightFactor: CGFloat = 0.55   // was 0.9 = too tall

            ZStack(alignment: .bottomLeading) {

                // Background grey bars
                HStack(alignment: .bottom, spacing: spacing) {
                    ForEach(values.indices, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.white.opacity(0.15))
                            .frame(
                                width: barWidth,
                                height: geo.size.height * barHeightFactor
                            )
                    }
                }

                // Foreground gradient bars
                HStack(alignment: .bottom, spacing: spacing) {
                    ForEach(normalized.indices, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(gradient)
                            .frame(
                                width: barWidth,
                                height: normalized[i] * geo.size.height * barHeightFactor
                            )
                    }
                }
            }
            .padding(.horizontal, 6)
            .padding(.top, 6)   // lifts chart upward slightly
        }
    }
}
