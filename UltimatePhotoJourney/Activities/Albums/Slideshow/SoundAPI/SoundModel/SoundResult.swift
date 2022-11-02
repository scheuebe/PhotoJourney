//
//  SoundResult.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 28.07.22.
//

import SwiftUI

struct SoundList: Codable {
    var count: Int
    var next: String
    var results: [SoundResult]
}

struct SoundResult: Codable {
    var id: Int
    var name: String
    var description: String
    var duration: Double
    var previews: PreviewLink
    var num_downloads: Int
    var avg_rating: Double
    var num_ratings: Int
    // var tags: [String]
    // var license: String
    // var username: String
}

struct SoundInstance: Codable {
    var id: Int
    // var url: String
    var name: String
    var description: String
    // var created: String
    // var channels: Int
    // var filesize: Int
    // var bitrate: Int
    // var bitdepth: Int
    var duration: Int
    // var sampleRate: Int
    // var username: String
    var previews: PreviewLink
    var num_downloads: Int
    var avg_rating: Int
    var num_ratings: Int
}

struct PreviewLink: Codable {
    var preview_lq_mp3: String
    
    enum CodingKeys: String, CodingKey {
        case preview_lq_mp3 = "preview-lq-mp3"
    }
}

extension SoundList {
    static let empty = SoundList(
                            count: -999,
                            next: "empty",
                            results: [
                                SoundResult(
                                    id: -999,
                                    name: "empty",
                                    description: "empty",
                                    duration: -999,
                                    previews: PreviewLink(preview_lq_mp3: "empty"),
                                    num_downloads: -999,
                                    avg_rating: -999,
                                    num_ratings: -999)
                            ]
                        )
}

extension SoundResult: Identifiable {
    var extId: Int { self.id }
}
