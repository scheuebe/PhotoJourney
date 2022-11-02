//
//  WeatherObjectController.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 19.05.22.
//  swiftlint:disable all

import Foundation
import SwiftUI

class WeatherObjectController: ObservableObject {
    static let shared = WeatherObjectController()
    private init() {
        // let weatherController = WeatherObjectController()
        // _weatherController = StateObject(wrappedValue: weatherController)
    }
    
    var token = "ADH4TUEJZ8LPJPB4SCVA44BK8"
    @Published var weatherResults = [Day]()
    @Published var location: String = "Augsburg"
    @Published var startDate: String = "2022-06-01"
    @Published var endDate: String = "2022-06-02"
    
    private func buildURLRequest() -> URLRequest {
        let url = URL(string: "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/\(location)/\(startDate)?unitGroup=metric&key=\(token)&options=nonulls&include=obs&elements=datetime,datetimeEpoch,temp,humidity,windspeed,uv-index,sunrise,sunset,description,icon")!
        /// debug for location fetching
        // print(location)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    func search() async -> WeatherResult {
        let request = buildURLRequest()
        
        do {
          let (data, response) = try await URLSession.shared.data(for: request)
          guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw fatalError()
          }
            let weatherResult = try JSONDecoder().decode(WeatherResult.self, from: data)
            /// debug for the weather meta data
            // print("Inside the new Search with a result: \(String(describing: weatherResult.days.last?.temp))")
            return weatherResult
        }
        catch {
            return WeatherResult.empty
        }
    }
}
