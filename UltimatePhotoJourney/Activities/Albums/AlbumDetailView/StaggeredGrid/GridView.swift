//
//  GridView.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 15.03.22.
//

import SwiftUI
import MapKit

struct GridView: View {
    // for real data
    @Binding var showItemImportSheet: Bool
    @ObservedObject var album: Album

    // To show dynamic...
    @State var columns: Int = 2

    // Smooth Hero Effect...
    @Namespace var animation

    var body: some View {
        VStack {
            HStack {
                Button {
                    showItemImportSheet.toggle()
                } label: {
                    HStack {
                        Image(systemName: "rectangle.stack.badge.plus")
                            .imageScale(.large)
                        Image(systemName: "photo.on.rectangle.angled")
                            .imageScale(.large)
                        Text("\(album.itemsCount)")
                    }
                }
                .padding(.horizontal, 6)

                Spacer()

                EditButton()
                    .font(.title3)
                    .padding(.horizontal, 6)

                Button {
                    columns += 1
                } label: {
                    Image(systemName: "minus.magnifyingglass")
                        .imageScale(.large)
                        .padding(3)
                }

                Button {
                    columns = max(columns - 1, 1)
                } label: {
                    Image(systemName: "plus.magnifyingglass")
                        .imageScale(.large)
                        .padding(3)
                }

            }
            .foregroundColor(.appColor)
            .padding(.top)
            .padding(.horizontal)

            Divider()
                .foregroundColor(.appColor)
                .padding(.horizontal)

            StaggeredGrid(columns: columns, list: album.albumItemsDefaultSorted, content: { item in

                // Post Card View...
                PostCardView(item: item)
                    .matchedGeometryEffect(id: item, in: animation)
            })
                .padding(.horizontal)
            // .navigationTitle("Staggered Grid")
            // animation...
                .animation(.easeInOut, value: columns)
        }
    }
}

// since we declared T as Identifiable...
// so we need to pass Idenfiable conform collection/Array...

struct PostCardView: View {
    // part of the swipe feature
    // var items: [Item]
    var item: Item

    // for delete Button
    @Environment(\.editMode) var editMode
    @EnvironmentObject var dataController: DataController

    var body: some View {
        if self.editMode?.wrappedValue == .active {
            Image(uiImage: UIImage(data: item.mediaData!) ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
                .overlay(
                    Image(systemName: "trash.circle.fill")
                            .font(.system(size: 20, weight: .bold))
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .padding(5)
                            .offset(x: 0, y: 0), alignment: .bottomTrailing
                )
                .background(NavigationLink(destination: EmptyView()) {
                    EmptyView()
                })
                    .onTapGesture {
                        deleteItem()
                }
        } else {
            NavigationLink(destination: ItemMapDetailView(
                // allItems: items,
                selectedImage: UIImage(data: item.mediaData!) ?? UIImage(),
                // index: getIndex(),
                date: item.creationDate,
                region: MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: item.itemLatitude,
                        longitude: item.itemLongitude),
                    span: MKCoordinateSpan(latitudeDelta: 7.5, longitudeDelta: 7.5)
                ))) {
                    Image(uiImage: UIImage(data: item.mediaData!) ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                }
        }
    }

    // part of the swipe feature
    /*
    func getIndex() -> Int {
        return items.firstIndex(of: item)!
    }
     */

    func deleteItem() {
        withAnimation {
            dataController.delete(item)
        }
    }
}
