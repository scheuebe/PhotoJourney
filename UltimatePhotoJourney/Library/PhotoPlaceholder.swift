//
//  PhotoPlaceholder.swift
//  PhotoJourney
//
//  Created by Bernhard Scheuermann on 04.11.21.
//

import SwiftUI

struct PhotoPlaceholder: View {
    var body: some View {
        ZStack {
            Image(systemName: "camera")
                .font(.system(size: 17))
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(
                    .secondary,
                    style: .init(
                        lineWidth: 3,
                        lineCap: .round,
                        lineJoin: .round,
                        miterLimit: .infinity,
                        dash: [10, 10],
                        dashPhase: 10)
                )
        }
        .foregroundColor(.secondary)
        .frame(width: 150, height: 105)
    }
}

struct PhotoPlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPlaceholder()
    }
}
