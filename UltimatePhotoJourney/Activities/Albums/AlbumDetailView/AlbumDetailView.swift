//
//  AlbumDetailView.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 04.02.22.
//

import SwiftUI
import MapKit

struct AlbumDetailView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var album: Album
    // @Binding var album: AlbumEntry
    var index: Int
    var namespace: Namespace.ID
    // var isAnimated = true

    // @Binding var item: [AlbumEntry]

    @State var viewState: CGSize = .zero
    @State var showSection = false
    @State var appear = [false, false, false]

    @State var location: CLLocationCoordinate2D?
    @State var creationDate: Date?

    // @State private var startDiashow = false
    @State var moreOptions = false
    @State var showEditAlbum = false
    @State var addPictures = false
    // solution to hide button for no pics
    // @State var noPicturesAdded = true
    @State private var showDeleteConfirmationAlert = false

    // Loading Screen
    @State private var showLoadingScreen = false

    // CustomPhotoPicker variables
    @State private var showItemImportSheet = false
    @State private var actualImportStatus: Int = 0
    @State private var amountOfPickedItems: Int = 0

    // slideshow start
    @State private var showSlideshow = false
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.editMode) var editMode

    var body: some View {
        VStack {
            ScrollView {
                cover
                    .overlay(
                        NavigationLink(destination:
                                        Slideshow(album: album)
                                       // Story(album: album)
                                      ) {
                                          PlayButton()
                                              .scaleEffect(0.85)
                                      }
                    )

                if (album.albumItems.count) > 0 {
                    photoGrid
                } else {
                    noPhotoGrid
                }
            }
        }
        .coordinateSpace(name: "scroll")
        .background(Color("Background"))
        .mask(RoundedRectangle(cornerRadius: viewState.width / 3))
        .modifier(OutlineModifier(cornerRadius: viewState.width / 3))
        .shadow(color: Color("Shadow").opacity(0.5), radius: 30, x: 0, y: 10)
        .scaleEffect(-viewState.width/500 + 1)
        .background(Color("Shadow").opacity(viewState.width / 500))
        .background(.ultraThinMaterial)
        .ignoresSafeArea()
        .sheet(isPresented: $showEditAlbum) {
            EditAlbumView(album: album)
        }
        .sheet(isPresented: $showItemImportSheet, onDismiss: startLoadingScreen) {
            CustomPhotoPickerView(
                album: album,
                actualImportStatus: $actualImportStatus,
                amountOfPickedItems: $amountOfPickedItems
            )
        }
        .alert("Are you sure?", isPresented: $showDeleteConfirmationAlert) {
            Button("Delete it", role: .destructive) {
                deleteAlbum()
            }
        }
        .overlay {
            if showLoadingScreen {
                LoadingScreen(
                    showLoadingScreen: $showLoadingScreen,
                    actualStatus: $actualImportStatus,
                    numberOfImport: $amountOfPickedItems,
                    loadingTitle: "Importing media"
                )
                .zIndex(10)
            }
        }
    }

    var cover: some View {
        GeometryReader { proxy in
            let scrollY = proxy.frame(in: .named("scroll")).minY

            VStack {
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: scrollY > 0 ? 500 + scrollY : 500)
            .background(
                AlbumCover(album: album)
                    .aspectRatio(1, contentMode: .fill)
                    .offset(y: scrollY > 0 ? -scrollY : 0)
                    .accessibility(hidden: true)

            )
             .mask(
                RoundedRectangle(cornerRadius: appear[0] ? 0 : 30)
                    .matchedGeometryEffect(id: "mask\(index)", in: namespace)
                    .offset(y: scrollY > 0 ? -scrollY : 0)
            )
            .overlay(
                Image(horizontalSizeClass == .compact ? "Waves 1" : "Waves 2")
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(y: scrollY > 0 ? -scrollY : 0)
                    .scaleEffect(scrollY > 0 ? scrollY / 500 + 1 : 1)
                    .opacity(1)
                    .matchedGeometryEffect(id: "waves\(index)", in: namespace)
                    .accessibility(hidden: true)
            )
            .overlay(
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(album.albumTitle)
                            .font(.title).bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.primary)
                            .matchedGeometryEffect(id: "title\(index)", in: namespace)

                        Spacer()

                        Button {
                            showEditAlbum.toggle()
                        } label: {
                            Image(systemName: "pencil")
                                .symbolRenderingMode(.palette)
                                .imageScale(.large)
                                .foregroundColor(.primary)
                                .padding(6)
                                .background(Circle().fill(.ultraThinMaterial))
                        }
                    }

                    if album.albumDetail != "" {
                        HStack {
                            Image(systemName: "location")
                                .foregroundColor(.primary.opacity(0.6))
                            Text(album.albumDetail.uppercased())
                                .font(.footnote).bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.primary.opacity(0.7))
                                .matchedGeometryEffect(id: "subtitle\(index)", in: namespace)
                        }
                    }

                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.primary.opacity(0.6))

                        Text("\(album.albumStartDate.formatted(date: .numeric, time: .omitted)) - \(album.albumEndDate.formatted(date: .numeric, time: .omitted))")
                            .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.primary.opacity(0.7))
                    }
                }
                .padding(20)
                .background(
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .cornerRadius(30)
                        .blur(radius: 30)
                        .matchedGeometryEffect(id: "blur\(index)", in: namespace)
                        .opacity(appear[0] ? 0 : 1)
                    )
                .background(
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .backgroundStyle(cornerRadius: 30)
                )
                .offset(y: scrollY > 0 ? -scrollY * 1.8 : 0)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .offset(y: -20)
                .padding(20)
            )
        }
        .frame(height: 350)
    }

    var noPhotoGrid: some View {
        ZStack {
            Rectangle()
                .fill(Color.clear)
                .frame(maxWidth: .infinity)
                .padding(20)
                .background(.ultraThinMaterial)
                .backgroundStyle(cornerRadius: 30)
                .padding(20)
                .padding(.vertical, 100)
            VStack {
                Spacer()
                Button {
                    resetEditMode()
                    showItemImportSheet.toggle()
                } label: {
                    HStack(alignment: .center) {
                        Image(systemName: "photo.on.rectangle")
                        Text("Start to import memories")
                    }
                    .foregroundColor(Color.appColor)
                }
                Spacer()
            }
        }
    }

    var photoGrid: some View {
/*
        AlbumGrid(album: album, pickedItems: self.pickedItems)
            // .aspectRatio(contentMode: .fill)
            .padding(20)
            .background(.ultraThinMaterial)
            .backgroundStyle(cornerRadius: 30)
            .padding(20)
            .padding(.vertical, 100)
*/

        GridView(showItemImportSheet: $showItemImportSheet, album: album)
            .background(.ultraThinMaterial)
            .backgroundStyle(cornerRadius: 30)
            .padding(20)
            .padding(.vertical, 100)

    }

    /*
    var drag: some Gesture {
        DragGesture(minimumDistance: 30, coordinateSpace: .local)
            .onChanged { value in
                guard value.translation.width > 0 else { return }
                
                if value.startLocation.x < 100 {
                    withAnimation {
                        viewState = value.translation
                    }
                }
                
                if viewState.width > 120 {
                    close()
                }
            }
            .onEnded { value in
                if viewState.width > 80 {
                    close()
                } else {
                    withAnimation(.openCard) {
                        viewState = .zero
                    }
                }
            }
    }*/

    func fadeIn() {
        withAnimation(.easeOut.delay(0.3)) {
            appear[0] = true
        }
        withAnimation(.easeOut.delay(0.4)) {
            appear[1] = true
        }
        withAnimation(.easeOut.delay(0.5)) {
            appear[2] = true
        }
    }

    func fadeOut() {
        withAnimation(.easeIn(duration: 0.1)) {
            appear[0] = false
            appear[1] = false
            appear[2] = false
        }
    }

    func savePhotosToAlbum() {

    }

    func resetEditMode() {
        editMode?.wrappedValue = .inactive
    }

    func startDiashow() {
        if album.itemsCount > 0 {

        }
    }

    func deleteAlbum() {
        withAnimation {
            dataController.delete(album)
            dataController.save()
            presentationMode.wrappedValue.dismiss()
        }
    }

    func startLoadingScreen() {
        showLoadingScreen = false
        showLoadingScreen.toggle()
    }

    // add delete function
    /*
    func deleteAlbum(at offsets: IndexSet) {
        withAnimation {
            let image = albums[offsets.first!]
            ModelData().removeImage(pathName: image.id.uuidString)
            albums.remove(atOffsets: offsets)
            ModelData().saveAlbum(pathName: "Albums", albums: albums)
        }
    }
     */
}

/*
struct AlbumDetailView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        AlbumDetailView(album: (albums[1]), namespace: namespace, item: .constant(albums[1]))
            .environmentObject(Model())
    }
}*/
