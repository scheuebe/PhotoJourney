//
//  ButtonPressViewModifier.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 30.08.22.
//

import Foundation
import SwiftUI

struct ButtonPressViewModifier: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in
                        onPress()
                    })
                    .onEnded({ _ in
                        onRelease()
                    })
            )
    }
}

extension View {
    func pressEvents(onPress: @escaping (() -> Void), onRelease: @escaping (() -> Void)) -> some View {
        modifier(ButtonPressViewModifier(onPress: {
            onPress()
        }, onRelease: {
            onRelease()
        }))
    }
}
