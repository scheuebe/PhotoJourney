//
//  WorldView.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 11.02.22.
//

import SwiftUI
import MapKit

struct WorldView: View {
    static let tag: String? = "World"
    @StateObject var viewModel: ViewModel
    @State private var showDetails = true

    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.items) { location in
            MapAnnotation(
                coordinate: CLLocationCoordinate2D(
                    latitude: location.itemLatitude,
                    longitude: location.itemLongitude
                ),
                anchorPoint: CGPoint(x: 0.5, y: 0.7)
                // tint: Color(location.album!.albumColor)*/
            ) {
                VStack {
                    /*
                     VStack {
                        Image(uiImage: UIImage(data: location.mediaData!) ?? UIImage())
                            .resizable()
                            .frame(width: 100, height: 100, alignment: .center)
                            .clipped()
                        Text(location.album!.albumTitle)
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(20)
                    .offset(x: 0, y: 112)
                    .opacity(showDetails ? 0 : 1)
                     */

                    Image(systemName: "mappin.circle")
                        .resizable()
                        // .imageScale(.large)
                        .foregroundColor(Color(location.album!.albumColor))
                        .background(.white)
                        .frame(width: 24, height: 24)
                        .clipShape(Circle())

                    // Text(location.resolvedAddress ?? "Empty")
                    //    .fixedSize()

                     Image(systemName: "arrowtriangle.down.fill")
                        .imageScale(.small)
                        .foregroundColor(Color(location.album!.albumColor))
                        .offset(x: 0, y: -2.75)

                    Spacer()
                 }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        viewModel.selectedPlace = location
                        showDetails = true
                    }
                }
            }
        }
        .ignoresSafeArea()
        .sheet(item: $viewModel.selectedPlace, onDismiss: nothingSelected) { place in
            WorldDetailView(item: viewModel.selectedPlace!, items: viewModel.selectedPlace!.album!.albumItems, region: viewModel.mapRegion)
            /*
             ItemMapDetailView(
                selectedImage: UIImage(data: (viewModel.selectedPlace?.mediaData!)!) ?? UIImage(),
                date: viewModel.selectedPlace?.creationDate,
                region: MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: viewModel.selectedPlace!.itemLatitude,
                        longitude: viewModel.selectedPlace!.itemLongitude),
                    span: MKCoordinateSpan(latitudeDelta: 7.5, longitudeDelta: 7.5)
                )
            )
             */
        }
    }

    func nothingSelected() {
        showDetails = false
        viewModel.selectedPlace = nil
    }
}

/*
struct WorldView_Previews: PreviewProvider {
    static var previews: some View {
        WorldView()
    }
}
 */
