import SwiftUI

struct MiniActivityChart: View {
    let values: [Double]

    // Normalize values for equal scale
    private var normalized: [Double] {
        let maxVal = values.max() ?? 1
        return values.map { max(0.05, $0 / maxVal) }
    }

    // ===========================
    //  BLUE FINANCE GRADIENT
    // ===========================
    private let blueGradient = LinearGradient(
        colors: [
            Color(red: 0.30, green: 0.64, blue: 1.00),  // #4DA3FF
            Color(red: 0.04, green: 0.52, blue: 1.00),  // #0A84FF
            Color(red: 0.00, green: 0.23, blue: 0.49)   // #003B7C
        ],
        startPoint: .bottom,
        endPoint: .top
    )

    var body: some View {
        GeometryReader { geo in
            let count = CGFloat(values.count)

            let barWidth = (geo.size.width / count) * 0.45
            let spacing = (geo.size.width - (barWidth * count)) / (count - 1)
            let barHeightFactor: CGFloat = 0.55

            ZStack(alignment: .bottomLeading) {

                // Background grey bars
                HStack(alignment: .bottom, spacing: spacing) {
                    ForEach(values.indices, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.white.opacity(0.10))
                            .frame(
                                width: barWidth,
                                height: geo.size.height * barHeightFactor
                            )
                    }
                }

                // BLUE gradient bars
                HStack(alignment: .bottom, spacing: spacing) {
                    ForEach(normalized.indices, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(blueGradient)
                            .frame(
                                width: barWidth,
                                height: normalized[i] * geo.size.height * barHeightFactor
                            )
                    }
                }
            }
            .padding(.horizontal, 6)
            .padding(.top, 6)
        }
    }
}
