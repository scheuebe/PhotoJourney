//
//  ColorManager.swift
//  PhotoJourney
//
//  Created by Bernhard Scheuermann on 04.03.22.
//

import SwiftUI

struct ColorManager {
    // color from icon background -> kind of the theme of the app
    static let appColor = Color("AppColor")

    // test to invert the color of the light/dark mode
    static let navigation = Color("Navigation")

    // background color
    static let background = Color("Background")
    
    // data of the meta data
    static let metaData = Color("MetaData")
}

extension Color {
    static let appColor = Color("AppColor")
    static let navigation = Color("Navigation")
    static let background = Color("Background")
    static let metaData = Color("MetaData")
}
