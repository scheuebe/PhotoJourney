//
//  ProjectView.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 10.01.22.
//

import SwiftUI

struct AlbumView: View {
    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"

    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var navigationModel: NavigationModel
    @StateObject var viewModel: ViewModel
    @State private var album = Album()
    @State private var showingSortOrder = false
    @State private var addNewAlbum = false

    // UI
    @State var show = true
    @State var showStatusBar = true
    @State var contentHasScrolled = false
    @Namespace var namespace

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    // future idea
    /*
     var sortOrderToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                showingSortOrder.toggle()
            } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
            }
        }
    }
     */

    var body: some View {
        NavigationView {
            Group {
                if viewModel.albums.isEmpty {
                    noAlbumLayout
                } else {
                    ScrollView {
                        scrollDetection

                        layout
                            .padding(.bottom, 100)
                    }
                }
            }
            .actionSheet(isPresented: $showingSortOrder) {
                ActionSheet(title: Text("Sort items"), message: nil, buttons: [
                    .default(Text("Optimized")) { viewModel.sortOrder = .optimized },
                    .default(Text("Creation Date")) { viewModel.sortOrder = .creationDate },
                    .default(Text("Title")) { viewModel.sortOrder = .title }
                ])
            }
            .sheet(isPresented: $addNewAlbum) {
                EditAlbumView(album: album)
            }
            .navigationBarHidden(true)
            .overlay(
                NavigationBar(
                    title: "Albums",
                    album: $album,
                    addNewAlbum: $addNewAlbum,
                    contentHasScrolled: $contentHasScrolled,
                    viewModel: viewModel
                )
            )
            .statusBar(hidden: !showStatusBar)
            .background(Background())
        }
        .accentColor(.appColor)
        .navigationViewStyle(.stack)
        .onAppear {
            navigationModel.showNav = true
        }

        // to enable the multi window layout on iPad and Mac
        // SelectSomethingView()
    }

    init(dataController: DataController, showClosedAlbums: Bool) {
        let viewModel = ViewModel(dataController: dataController, showClosedAlbums: showClosedAlbums)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    @ViewBuilder
    var layout: some View {
        VStack {
            if horizontalSizeClass == .regular {
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: show ? 240 : 700), spacing: 16)],
                    spacing: 16) {
                    content
                }
            } else {
                VStack(spacing: show ? 30 : -180) {
                    content
                }
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8))
        .padding(20)
        .offset(y: 40)
    }

    var content: some View {
        ForEach(viewModel.albumsSorted.indices, id: \.self) { index in
            GeometryReader { _ in
                VStack(alignment: .center) {
                    NavigationLink(destination: AlbumDetailView(album: viewModel.albumsSorted[index], index: index, namespace: namespace)) {
                        AlbumRowView(album: viewModel.albumsSorted[index])
                    }
                }
                .overlay(
                    withAnimation {
                        DeleteAlbumButton(index: index, album: viewModel.albumsSorted[index], onDelete: deleteAlbum)
                    }
                    .offset(x: 10, y: -12),
                    alignment: .topTrailing
                 )
                .animation(.spring(response: 0.4, dampingFraction: 0.8))
            }
            .zIndex(Double(index))
            .frame(height: 260)
        }
    }

    var scrollDetection: some View {
        GeometryReader { proxy in
            let offset = proxy.frame(in: .named("scroll")).minY
            Color.clear.preference(key: ScrollPreferenceKey.self, value: offset)
        }
        .onPreferenceChange(ScrollPreferenceKey.self) { value in
            withAnimation(.easeInOut) {
                if value < 0 {
                    contentHasScrolled = true
                } else {
                    contentHasScrolled = false
                }
            }
        }
    }
    
    var noAlbumLayout: some View {
        ZStack {
            GeometryReader { geo in
                Rectangle()
                    .fill(.black.opacity(0.01))
                    .padding()
                    .frame(width: geo.size.width, height: geo.size.height-geo.safeAreaInsets.top)
            }
            
            Button {
                album = viewModel.addAlbum()
                addNewAlbum.toggle()
            } label: {
                VStack {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                        .shadow(color: .black, radius: 1, x: 0, y: 0)
                        .foregroundColor(.appColor)
                        .padding(.top)
                        .padding(.bottom, 7)
                        
                    Text("Add your first album 😊")
                        .foregroundColor(.appColor)
                        .padding(.horizontal, 14)
                        .padding(.bottom)
                }
                .padding()
                .background(.white)
                .cornerRadius(14)
                .shadow(color: .black, radius: 3, x: 0, y: 0)
            }
        }
    }

    func deleteAlbum(at offsets: IndexSet) {
        withAnimation {
            let albumIndex = viewModel.albums[offsets.first!]
            dataController.delete(albumIndex)
        }
    }

    private func binding(for album: Album) -> Binding<Album> {
        guard let albumIndex = viewModel.albums.firstIndex(where: { $0.id == album.id }) else {
            fatalError("Can't find album in array")
        }
        return $viewModel.albums[albumIndex]
    }
}

struct AlbumView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        AlbumView(dataController: DataController.preview, showClosedAlbums: false)
    }
}
