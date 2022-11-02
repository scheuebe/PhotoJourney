//
//  ViewModifier+ViewExtension.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 25.08.22.
//

import SwiftUI

struct SwipeToDismissModifier: ViewModifier {
    // var onDismiss: () -> Void
    @State private var offset: CGSize = .zero
    @Environment(\.presentationMode) var presentationMode

    func body(content: Content) -> some View {
        content
            .offset(y: offset.height)
            .animation(.interactiveSpring(), value: offset)
            .simultaneousGesture(
                DragGesture()
                    .onChanged { gesture in
                        if gesture.translation.width < 50 {
                            offset = gesture.translation
                        }
                    }
                    .onEnded { _ in
                        if (offset.height) > 100 {
                            // onDismiss()
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            offset = .zero
                        }
                    }
            )
    }
}

extension View {
    func swipeToDismiss() -> some View {
        modifier(SwipeToDismissModifier())
    }
}
