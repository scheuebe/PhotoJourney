//
//  Binding-OnChange.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 11.01.22.
//

import SwiftUI

// to update other views without the need of "onChange" for every attribute of item / album
extension Binding {

    // @escaping leaves the method all the time alive which is needed to watch permanently the objects for changes
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}
