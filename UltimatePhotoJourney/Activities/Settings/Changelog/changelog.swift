//
//  changelog.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 27.08.22.
//

import Foundation

struct changelog: Decodable, Identifiable {
    var id: Int
    var date: String
    var features: String
}
