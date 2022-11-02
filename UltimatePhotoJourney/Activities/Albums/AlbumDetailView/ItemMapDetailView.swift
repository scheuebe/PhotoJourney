//
//  ItemMapDetailView.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 25.01.22.
//

import SwiftUI
import MapKit

struct ItemMapDetailView: View {
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    @State private var offset = CGSize.zero
    // @State var allItems: [Item]
    @State var selectedImage: UIImage?
    // @State var index: Int
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
                    latitude: region.center.latitude + region.span.latitudeDelta * 0.30,
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
                MapMarker(coordinate: coord, tint: .appColor)
            }
                .ignoresSafeArea(edges: .all)
            VStack {
                ZStack {
                     if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                    
                    ZStack {
                        if let date = date {
                            Text("\(date, formatter: Self.dateFormat)")
                                .foregroundColor(.appColor)
                                .padding(.top, 4)
                                .padding(.bottom, 10)
                        }
                    }
                    .frame(width: 320)
                    .background(.white)
                    .offset(x: 0, y: +145)
                }
                .frame(width: 320, height: 320, alignment: .center)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10)
                .padding(20)
                // swipe gestures as a future feature
                /*
                .rotationEffect(.degrees((Double(offset.width / 5))))
                .offset(x: offset.width * 5, y: 0)
                .opacity(2 - Double(abs(offset.width / 50)))
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            self.offset = gesture.translation
                        }
                        .onEnded { _ in
                            if abs(offset.width) > 100 {
                                if self.offset.width > 0 {
                                    print("SWIPE right")
                                    // selectedImage = UIImage(data: allItems[index-1].mediaData!)
                                } else {
                                    print("SWIPE left")
                                    // selectedImage = UIImage(data: allItems[index+1].mediaData!)
                                }
                            } else {
                                offset = .zero
                            }
                        }
                )
                .animation(.spring(), value: offset)
                 */

                
                // another idea to display country and date
                /*
                HStack {
                    Text("DE")
                        .font(.footnote)
                    
                    Text("•")
                        .font(.title)
                    
                    if let date = date {
                        Text("\(date, formatter: Self.dateFormat)")
                    }
                }
                .padding(8)
                .background(.white)
                .cornerRadius(10)
                .foregroundColor(.appColor)
                .padding(8)
                 */
                
                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
        }
        // part of the DEBUG of the swipe feature
        /*
        .onAppear {
            selectedImage = UIImage(data: allItems[index].mediaData!)
            print("Index in MapView \(index)")
        }
         */
    }
}

/*
struct ItemMapDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ItemMapDetailView()
    }
}
 */

extension CLLocationCoordinate2D: Identifiable, Hashable, Equatable {
    public var id: Int {
        return hashValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }

    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.longitude == rhs.longitude && lhs.latitude == rhs.latitude
    }

    public static func < (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.longitude < rhs.longitude
    }
}
