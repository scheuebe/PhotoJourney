//
//  ItemMapDetailView.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 25.01.22.
//

import SwiftUI
import MapKit

struct WorldDetailView: View {
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    var item: Item
    var items: [Item]
    @State var selectedImage: UIImage?
    @State var date: Date?
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 20.0,
            longitude: 20.0),
        span: MKCoordinateSpan(latitudeDelta: 7.5, longitudeDelta: 7.5))

    var body: some View {
        let regionWithOffset = Binding<MKCoordinateRegion>(
            get: {
                let offsetCenter = CLLocationCoordinate2D(
                    latitude: region.center.latitude + region.span.latitudeDelta * 0.37,
                    longitude: region.center.longitude
                )
                return MKCoordinateRegion(
                    center: offsetCenter,
                    span: region.span)
            },
            set: {
                $0
            }
        )
        return ZStack {
            Map(coordinateRegion: regionWithOffset,
                interactionModes: MapInteractionModes.all,
                showsUserLocation: false,
                annotationItems: [region.center]) { coord in
                MapMarker(coordinate: coord, tint: Color(item.album!.albumColor))
                // to show all markers
                /*
                 annotationItems: items) { coord in
                 MapMarker(coordinate: CLLocationCoordinate2D(latitude: coord.itemLatitude, longitude: coord.itemLongitude), tint: .appColor)
                 */
            }
                .ignoresSafeArea(edges: .all)
            VStack(spacing: 0) {
                ZStack {
                    if let image = UIImage(data: item.mediaData!) ?? UIImage() {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                }
                .frame(height: 330, alignment: .center)
                .clipped()

                ZStack {
                    ImageMetaData(item: item)
                        .foregroundColor(.primary.opacity(0.7))
                        .padding(.horizontal)
                        .background(
                            Rectangle()
                                .fill(.ultraThinMaterial)
                        )
                }
                Spacer()
            }
        }
        .onAppear(perform: getLocation)
    }

    func getLocation() {
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: item.itemLatitude,
                longitude: item.itemLongitude),
            span: MKCoordinateSpan(latitudeDelta: 7.5, longitudeDelta: 7.5))
    }
}
