import Foundation
import SwiftUI

struct ActivityTile: View {
    let values: [Double]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            Text("Yearly Activity")
                .font(.headline)
                .foregroundColor(Color.primary.opacity(0.9))    // ADAPTIVE

            MiniActivityChart(values: values)
                .frame(maxHeight: .infinity)
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(.secondarySystemBackground))        // ADAPTIVE TILE
        )
    }
}
