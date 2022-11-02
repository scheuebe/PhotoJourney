//
//  SFSymbolViewModifier.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 27.08.22.
//

import SwiftUI

struct SymbolWidthModifier: ViewModifier {
    @Binding var width: Double

    func body(content: Content) -> some View {
        content
            .background(GeometryReader { geo in
                Color
                    .clear
                    .preference(key: SymbolWidthPreferenceKey.self, value: geo.size.width)
            })
    }
}

struct SymbolWidthPreferenceKey: PreferenceKey {

    static var defaultValue: Double = 0

    static func reduce(value: inout Double, nextValue: () -> Double) {
        value = max(value, nextValue())
    }
}
