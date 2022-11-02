//
//  WeatherDataView.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 02.02.22.
//
//  idea of the implementation with viewModel: https://peterfriese.dev/posts/swiftui-concurrency-essentials-part1/

import SwiftUI
import MapKit

struct WeatherDataView: View {
    var location: CLLocationCoordinate2D
    var creationDate: String
    
    @State var weatherController = WeatherObjectController.shared
    @State var days = [Day]()
    @State var isSearching = true

    var body: some View {
        VStack(alignment: .leading) {
            /// DEBUG
            // location from API
            // Text(weatherController.location)
            //
            // Text(weatherController.startDate)
            // Text("description: \(description)")
            
            if isSearching {
                ProgressView()
            } else {
                HStack {
                    ForEach(days) { day in
                        if day.temp != nil && day.temp != -999.0 {
                            Text("•")
                                .font(.title)
                                .offset(y: -1)
                            
                            if day.icon == "clear-day" {
                                Image(systemName: "sun.max.fill")
                                    .symbolRenderingMode(.multicolor)
                                    .font(.body.weight(.bold))
                                    .shadow(radius: 1)
                                //.foregroundColor(.primary.opacity(0.7))
                            } else if day.icon == "rain" {
                                Image(systemName: "cloud.rain.fill")
                                    .symbolRenderingMode(.multicolor)
                                    .font(.body.weight(.bold))
                                    .shadow(radius: 1)
                                //.foregroundColor(.primary.opacity(0.7))
                            } else if day.icon == "wind" {
                                Image(systemName: "wind")
                                    .symbolRenderingMode(.multicolor)
                                    .font(.body.weight(.bold))
                                    .shadow(radius: 1)
                                //.foregroundColor(.primary.opacity(0.7))
                            } else if day.icon == "partly-cloudy-day" {
                                Image(systemName: "cloud.fill")
                                    .symbolRenderingMode(.multicolor)
                                    .font(.body.weight(.bold))
                                    .shadow(radius: 1)
                                //.foregroundColor(.primary.opacity(0.7))
                            } else if day.icon == "snow" {
                                Image(systemName: "cloud.snow.fill")
                                    .symbolRenderingMode(.multicolor)
                                    .font(.body.weight(.bold))
                                    .shadow(radius: 1)
                                //.foregroundColor(.primary.opacity(0.7))
                            } else {
                                Text("")
                            }
                            
                            let formattedTemp = String(format: "%.1f", day.temp ?? "")
                            Text("\(formattedTemp)°C")
                                .font(.footnote.weight(.semibold))
                                .offset(x: -4)
                        }
                    }
                }
            }
            
            // additional weatherdata
            /*
             HStack {
             Image(systemName: "humidity")
             Text("hum: \(humidity)")
             }
             
             HStack {
             Image(systemName: "wind")
             Text("windspeed: \(windspeed)")
             }
             
             HStack {
             Image(systemName: "sunrise")
             Text(sunrise)
             }
             
             HStack {
             Image(systemName: "sunset")
             Text(sunset)
             }
             */
        }
        .task {
            weatherController.location = "\(location.latitude),\(location.longitude)"
            weatherController.startDate = creationDate
            let result = await weatherController.search()
            days = result.days
            /// debug to look if weather meta data is transferred
            // print("in task \(String(describing: days.last?.temp))")
            isSearching = false
        }
        .onDisappear {
            isSearching = true
        }
    }
}

/*
struct WeatherDataView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDataView()
    }
}
 */
