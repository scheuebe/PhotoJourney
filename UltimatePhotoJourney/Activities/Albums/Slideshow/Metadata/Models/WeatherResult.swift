//
//  WeatherResult.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 19.05.22.
//
//  find all possible API calls here: https://www.visualcrossing.com/resources/documentation/weather-api/timeline-weather-api/

import Foundation
import SwiftUI

struct WeatherResult: Codable {
    var queryCost: Int
    var latitude: Double
    var longitude: Double
    var resolvedAddress: String
    var address: String
    var timezone: String
    var tzoffset: Int
    // needed for forecast
    // var description: String?
    var days: [Day]
    // needed for forecast
    // var alerts: [Alert]
}

struct Day: Codable {
    var datetime: String
    // var datetimeEpoch: Int
    // var tempmax: Double?
    // var tempmin: Double?
    var temp: Double?
    // var feelslikemax: Double?
    // var feelslikemin: Double?
    // var feelslike: Double?
    // var dew: Int?
    var humidity: Double?
    // var precip: Double?
    // var precipprob: Double?
    // var precipcover: Double?
    // var preciptype: [PrecipTypes]?
    // var snow: Double?
    // var snowdepth: Double?
    // var windgust: String?
    // var windspeed: Double?
    // var winddir: Double?
    // var pressure: Double?
    // var cloudcover: Double?
    // var visibility: Double?
    // var solarradiation: Double?
    // var solarenergy: Double?
    // var uvindex: Double?
    var sunrise: String?
    // var sunriseEpoch: Int?
    var sunset: String?
    // var sunsetEpoch: Int?
    var moonphase: Double?
    // var conditions: String?
    var description: String?
    var icon: String?
    // var stations: [Station]?
    // var source: String?
    // var hours: [Hour]?
}

/*
struct Station: Codable {
    var distance: Int?
    var latitude: Double?
    var longitude: Double?
    var useCount: Int?
    var id: String
    var name: String?
    var quality: Int?
    var contribution: Int?
}

struct Hour: Codable {
    var datetime: String
    var datetimeEpoch: Int
    var temp: Double?
    var feelslike: Double?
    var humidity: Double?
    var dew: Int?
    var precip: Double?
    var precipprob: Double?
    var snow: Double?
    var snowdepth: Double?
    var preciptype: [PrecipTypes?]
    var windgust: String?
    var windspeed: Double?
    var winddir: Int?
    var pressure: Double?
    var visibility: Double?
    var cloudcover: Double?
    var solarradiation: Double?
    var solarenergy: Double?
    var uvindex: Int?
    var conditions: String?
    var icon: String?
    var stations: [Station?]
    var source: String?
}

struct PrecipTypes: Codable {
    var type: String
}

/*
struct Alert: Codable {
    var event: String?
    var description: String?
}
 */

struct CurrentCondition: Codable {
    var datetime: String
    var datetimeEpoch: Int
    var temp: Double?
    var feelslike: Double?
    var dew: Int?
    var humidity: Int?
    var precip: Double?
    var precipprob: Double?
    var snow: Double?
    var snowdepth: Double?
    var preciptype: [PrecipTypes?]
    var windgust: String?
    var windspeed: Double?
    var winddir: Int?
    var pressure: Double?
    var cloudcover: Double?
    var visibility: Double?
    var solarradiation: Double?
    var solarenergy: Double?
    var uvindex: Double?
    var conditions: String?
    var icon: String?
    var stations: [Station?]
    var sunrise: String?
    var sunriseEpoch: Int?
    var sunset: String?
    var sunsetEpoch: Int?
    var moonphase: Double?
}
*/

extension Day: Identifiable {
    var id: String { self.datetime }
}

extension WeatherResult {
    static let empty = WeatherResult(
                            queryCost: -1,
                            latitude: -1,
                            longitude: -1,
                            resolvedAddress: "Empty",
                            address: "Empty",
                            timezone: "Empty",
                            tzoffset: -1,
                            days: [
                                Day(
                                    datetime: "Empty",
                                    temp: -999,
                                    humidity: -1,
                                    sunrise: "Empty",
                                    sunset: "Empty",
                                    moonphase: -1,
                                    description: "Empty",
                                    icon: "Empty"
                                )
                            ]
                        )
}
