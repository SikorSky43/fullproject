//
//  ActivityTile.swift
//  Angelos
//
//  Created by BlackBird on 20/11/25.
//

import Foundation
import SwiftUI

// ------------------------------------------------------
// MARK: - Activity Tile
// ------------------------------------------------------

struct ActivityTile: View {
    let values: [Double]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Yearly Activity")
                .font(.headline)
                .foregroundColor(.white.opacity(0.95))

            MiniActivityChart(values: values)
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(red: 0.11, green: 0.11, blue: 0.12))
        )
    }
}
