//
//  Strings.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 13.01.22.
//

//  easier way to store Strings for the purpose to be localized later
import SwiftUI

enum Strings: LocalizedStringKey {
    case appWelcomeMessage
    case updateSettings
}

// needed for every kind of UI like TextField, etc.
extension Text {
    init(_ localizedString: Strings) {
        self.init(localizedString.rawValue)
    }
}
