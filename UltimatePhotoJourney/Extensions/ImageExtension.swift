//
//  ImageExtension.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 27.08.22.
//

import SwiftUI


extension Image {
    func sync(with width: Binding<Double>) -> some View {
         modifier(SymbolWidthModifier(width: width))
    }
}
