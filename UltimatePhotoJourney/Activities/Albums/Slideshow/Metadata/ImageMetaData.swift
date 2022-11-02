//
//  MetaDataView.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 16.03.22.
//

import SwiftUI
import MapKit

struct ImageMetaData: View {
    @AppStorage("showExactLocation") var showExactLocation: Bool = true
    @AppStorage("showCountryNameInMetadata") var showCountryNameInMetadata: Bool = true
    @AppStorage("showAlbumNameInMetadata") var showAlbumNameInMetadata: Bool = false
    
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    var item: Item
    @State private var reversedGeolocation: String = ""
    @State private var isoCountryFlag: UIImage?
    @State private var country: String = ""
    @State private var isoCountryCode: String = ""
    @State private var timeZone: TimeZone = .current

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if showExactLocation {
                Text("\(reversedGeolocation)")
                    .font(.title2)
                    .bold()
            }
            
            if item.album?.albumTitle != nil && showAlbumNameInMetadata {
                Text(item.album!.albumTitle)
                    .font(.footnote)
            }

            HStack(alignment: .center) {
                // bug: some country flags are cropped -> no idea
                if isoCountryCode != "" {
                    Image("\(isoCountryCode.lowercased())")
                        .resizable()
                        .frame(width: 16, height: 12)
                        .scaledToFit()
                        .cornerRadius(1)
                        .shadow(radius: 2)
                    
                    if showCountryNameInMetadata {
                        Text(country)
                            .font(.footnote.weight(.semibold))
                    }

                    Text("•")
                        .font(.title)
                        .offset(y: -1)
                }

                Text("\(item.itemCreationDate, formatter: Self.dateFormat)")
                    .font(.footnote.weight(.semibold))
                    // .foregroundColor(.metaData)

                WeatherDataView(location: CLLocationCoordinate2D(latitude: item.itemLatitude, longitude: item.itemLongitude), creationDate: item.itemAPIFormattedDate)
                
                Spacer()
            }
            .padding(2)
            
            
        }
        //.padding([.horizontal], 8)
        .padding()
        .onAppear {
            reverseGeocode(with: CLLocationCoordinate2D(latitude: item.itemLatitude, longitude: item.itemLongitude))
        }
    }

    func reverseGeocode(with location: CLLocationCoordinate2D)/*, completion: @escaping ((String?)  */ /*-> String*/ {

        // print("Im in the reverse geocode function")

        let cllocation = CLLocation(latitude: location.latitude, longitude: location.longitude)

        // print("cllocation initialised")

        let geocoder = CLGeocoder()
        // print("geocoder initialised")
        geocoder.reverseGeocodeLocation(cllocation, preferredLocale: .current) {
            placemarks, error in
            guard let place = placemarks?.first, error == nil else {
                // completion(nil)
                // showInternetError.toggle()
                return
                // print("error encoding placemark")
            }
            /// debug to double check the result of the geocoder API
            // print("inside of geocoder")
            // print(place)

            var name: String = ""

            // find solution not to show numbers
            // solution to avoid empty places with "," in the beginning

            if let placeName = place.name {
                let digitCharacters = CharacterSet.decimalDigits

                // hide if just number
                if placeName.rangeOfCharacter(from: digitCharacters) == nil {
                    name += "\(placeName), "
                }
            }

            if let subAdministrativeArea = place.subAdministrativeArea {
                name += "\(subAdministrativeArea), "
            }

            if let administrativeArea = place.administrativeArea {
                if place.subAdministrativeArea == place.administrativeArea {
                    if let locality = place.locality {
                        name += "\(locality)"
                    }
                } else {
                    name += "\(administrativeArea)"
                }
            }

            /*
            if let locality = place.locality {
                name += "\(locality), "
            }
             */

            /*
            if let subLocality = place.subLocality {
                name += "\(subLocality), "
            }
            */

            /*
            if let thoroughfare = place.thoroughfare {
                name += "\(thoroughfare), "
            }
            */

            /*
            if let subThoroughfare = place.subThoroughfare {
                name += "\(subThoroughfare), "
            }
            */

            if let country = place.country {
                self.country = country
            }

            if let isoCountryCode = place.isoCountryCode {
                self.isoCountryCode = isoCountryCode
                isoCountryFlag = UIImage(named: "\(isoCountryCode)")
            }

            if let timeZone = place.timeZone {
                self.timeZone = timeZone
            }

            if name.hasPrefix(" ") {
                let str = name.dropFirst()
                name = String(str)
            }
            
            if name.hasSuffix(", ") {
                let str = name.dropLast(2)
                name = String(str)
            }
            
            reversedGeolocation = name
            // print(reversedGeolocation)
            // savePick()
        }
        // reversedGeolocation = name
        // return reversedGeolocation
    }
}

/*
struct MetaDataView_Previews: PreviewProvider {
    static var previews: some View {
        MetaDataView()
    }
}
 */
