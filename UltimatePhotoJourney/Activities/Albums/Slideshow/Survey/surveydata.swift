//
//  surveyData.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 13.09.22.
//

import Foundation

struct surveydata: Decodable, Identifiable {
    var id: Int
    var title: String
    var creationDate: String
    var latitude: Double
    var longitude: Double
    var mediaData: String
}
