//
//  Results.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 15.09.22.
//

import Foundation
import SwiftUI

struct ImageAPIResponse: Codable {
    var total: Int
    // var totalPages: Int
    var imageResults: [ImageResult]
}

struct ImageResult: Codable {
    var id: String
    var created_at: String
    var description: String?
    var urls: ImageURLs
    var location: Location?
}

struct ImageURLs: Codable {
    // var thumb: String
    // var small: String
    // var regular: String
    var full: String
    // var raw: String
}

struct Location: Codable {
    var name: String?
    var city: String?
    var country: String?
    var position: Position?
}

struct Position: Codable {
    var latitude: Double?
    var longitude: Double?
}

extension ImageResult {
    static let empty = ImageResult(
        id: "empty",
        created_at: "empty",
        urls:
            ImageURLs(
                full: "empty"
            ),
        location: Location(
            name: "empty",
            city: "empty",
            country: "empty",
            position: Position(
                latitude: 11.11,
                longitude: 11.11
            )
        )
    )
}
