//
//  OnTapModifier.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 26.08.22.
//

import SwiftUI

struct OnTapModifier: ViewModifier {
    let response: (CGPoint) -> Void
    
    @State private var location: CGPoint = .zero
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                response(location)
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { location = $0.location }
            )
    }
}

extension View {
    func onTapGesture(_ handler: @escaping (CGPoint) -> Void) -> some View {
        self.modifier(OnTapModifier(response: handler))
    }
}
