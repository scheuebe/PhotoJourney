//
//  HexagonView.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 22.05.22.
//
//  swiftlint:disable all

import SwiftUI

struct HexagonView: View {
    var body: some View {
        Canvas { context, size in
            let image = context.resolve(Image(systemName: "hexagon.fill"))
            let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            context.draw(image, in: frame)
        }
        .frame(width: 200, height: 220)
        .foregroundStyle(.linearGradient(colors: [.red, .orange.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}

struct HexagonView_Previews: PreviewProvider {
    static var previews: some View {
        HexagonView()
    }
}
