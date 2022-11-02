//
//  TabModel.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 18.02.22.
//
//  swiftlint:disable all

import SwiftUI

struct TabItem: Identifiable {
    let id = UUID()
    var name: String
    var icon: String
    var color: Color
    var selection: Tab
}

var tabItems = [
    // TabItem(name: "Home", icon: "house", color: .teal, selection: .home),
    TabItem(name: "Albums", icon: "photo.on.rectangle.angled", color: .appColor /* color: .teal */, selection: .albums),
    TabItem(name: "World", icon: "map", color: .appColor /*color: .blue*/, selection: .world),
    // TabItem(name: "ML", icon: "photo", color: .appColor, selection: .ml),
    // TabItem(name: "Story", icon: "photo", color: .appColor, selection: .story),
    TabItem(name: "Me", icon: "person.fill", color: .appColor /*color: .red*/, selection: .me),
    TabItem(name: "Settings", icon: "gear", color: .appColor /*color: .pink*/, selection: .settings)
]

enum Tab: String {
    // case home
    case albums
    case world
    case me
    case settings
    // case ml
    // case story
}
