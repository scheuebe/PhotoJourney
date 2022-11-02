//
//  EditProjectView.swift
//  UltimatePortfolio
//
//  Created by Bernhard Scheuermann on 11.01.22.
//

import SwiftUI
import MapKit
import PhotosUI

struct EditAlbumView: View {
    let album: Album

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode

    // variables of album
    @State private var convertedInputImage: Image?
    // @State private var coverImage: Data
    @State private var title: String
    @State private var detail: String
    @State private var startDate: Date
    @State private var endDate: Date
    @State private var color: String
    @State private var showingDeleteConfirm = false

    // Loading Screen
    @State private var showLoadingScreen = false

    // Image Picker
    @State private var inputImage: UIImage?
    @State private var showImagePicker = false
    @State private var showMultipleImagePicker = false
    @State private var pickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showConfirmationDialog = false
    @State private var locations = [CodeableMKPointAnnotation]()
    @State private var centerCoordinate = CLLocationCoordinate2D()

    // CustomPhotoPicker
    @State private var pickedImages = [PickedMediaItem]()
    @State private var actualImportStatus: Int = 0
    @State private var amountOfPickedItems: Int = 0

    @State private var showPhotoDeleteConfirmationAlert = false
    @State private var selectedIndex: Int?

    /// used to center the map view
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 20.0,
            longitude: 20.0),
        latitudinalMeters: .init(10000),
        longitudinalMeters: .init(10000))

    let locationFetcher = LocationFetcher()

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    init(project: Album) {
        self.album = project

        _title = State(wrappedValue: project.albumTitle)
        _detail = State(wrappedValue: project.albumDetail)
        _color = State(wrappedValue: project.albumColor)
        _startDate = State(wrappedValue: project.albumStartDate)
        _endDate = State(wrappedValue: project.albumEndDate)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Photo")) {
                    HStack {
                        VStack {
                            if inputImage != nil {
                                Image(uiImage: inputImage ?? UIImage())
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 105)
                                    .cornerRadius(10)
                            } else if album.coverImage != nil {
                                    Image(uiImage: UIImage(data: album.coverImage!) ?? UIImage())
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 150, height: 105)
                                        .cornerRadius(10)
                            } else {
                                PhotoPlaceholder()
                            }
                        }
                        .padding(.trailing, 20)
                        .padding(.vertical, 10)

                        Button {
                            showImagePicker.toggle()
                        } label: {
                            Text("Pick a cover photo")
                                .font(.footnote)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.appColor)
                        .clipShape(Capsule())
                    }
                    .onTapGesture {
                        self.showConfirmationDialog = true
                    }
                }

                Section("Description") {
                    HStack {
                        Image(systemName: "tag")
                            .padding(.trailing, 10)
                            .padding(.vertical, 10)
                            .foregroundColor(.appColor)
                        // Text("Tomorrowland")
                        TextField("Album name", text: $title)
                    }
                    HStack {
                        Image(systemName: "location")
                            .padding(.trailing, 10)
                            .padding(.vertical, 10)
                            .foregroundColor(.appColor)
                        // Text("Boom, Belgium")
                        TextField("Location", text: $detail)
                    }
                }

                Section(
                    header: Text("Date"),
                    footer: HStack(alignment: .center) {
                        Spacer()
                        Button {
                            showingDeleteConfirm.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete Album")
                            }
                            .padding(10)
                            .foregroundColor(Color.red)
                            Text("Deleting removes the album with all its stored photos entirely.")
                        }
                        Spacer()
                    },
                    content: {
                        HStack {
                            Image(systemName: "calendar.badge.clock")
                                .padding(.trailing, 10)
                                .padding(.vertical, 10)
                                .foregroundColor(.appColor)
                            DatePicker(selection: $startDate, in: ...Date(), displayedComponents: .date) {
                                Text("Select the start of your trip")
                            }
                        }
                        HStack {
                            Image(systemName: "calendar.badge.clock")
                                .padding(.trailing, 10)
                                .padding(.vertical, 10)
                                .foregroundColor(.appColor)
                            DatePicker(selection: $endDate, in: ...Date(), displayedComponents: .date) {
                                Text("Select the end of your trip")
                            }
                        }
                    })

                Section(header: Text("Memories")) {
                    // UI header of memories
                    HStack {
                        Button {
                            // addItem(to: album)
                            self.showMultipleImagePicker.toggle()
                        } label: {
                            Image(systemName: "rectangle.stack.badge.plus")
                                .font(.system(size: 20))
                                .foregroundColor(Color.gray)
                        }
                        Spacer()

                        Text("\(pickedImages.count + self.album.albumItems.count) \(Image(systemName: "photo.on.rectangle.angled"))")
                            .foregroundColor(.gray)
                    }

                    // Button to add new memories
                    Button {
                        withAnimation {
                            addItem(to: album)
                        }
                    } label: {
                        Label("Add New Item", systemImage: "plus")
                            .foregroundColor(Color(album.albumColor))
                    }

                    // Grid of saved items
                    if !album.albumItems.isEmpty {
                        LazyVGrid(columns: [
                            GridItem(.adaptive(minimum: 100), spacing: 5)], spacing: 5) {
                                ForEach(album.albumItems) { item in
                                    ItemRowView(album: album, item: item)
                                }
                            }
                    } else {
                        LazyVGrid(columns: [
                            GridItem(.adaptive(minimum: 100, maximum: 100), spacing: 5)], spacing: 5) {
                                ForEach(pickedImages.indices, id: \.self) { index in
                                    Image(uiImage: pickedImages[index].selectedImage ?? UIImage())
                                        .resizable()
                                        .frame(width: 100, height: 100, alignment: .center)
                                        .overlay(
                                            Image(systemName: "trash.circle.fill")
                                                    .font(.system(size: 20, weight: .bold))
                                                    .background(Color.red)
                                                    .foregroundColor(.white)
                                                    .clipShape(Circle())
                                                    .padding(5)
                                                    .offset(x: 0, y: 0), alignment: .bottomTrailing
                                        )
                                        /// NavigationLink to allow the interaction with each indivual picture.
                                        /// Otherwise the Grid responds as a whole unit
                                        /// A wrapped button around the image, a VStack with Image and Button
                                        /// or an Image with any kind of overlay do NOT work
                                        .background(NavigationLink(destination: EmptyView()) { EmptyView() })
                                                        .onTapGesture {
                                            deletePhoto(at: index)
                                        }
                                }
                            }
                    }
                }

                Section(header: Text("Custom Project Color")) {
                    LazyVGrid(columns: colorColumns) {
                        ForEach(Album.colors, id: \.self) { item in
                            colorButton(for: item)
                        }
                    }
                    .padding(.vertical)
                }

                // swiftlint:disable:next line_length
                Section(footer: Text("Closing a album moves it from the Open to Closed tab; deleting it removes the album entirely.")) {
                    Button(album.closed ? "Reopen this album" : "Close this album") {
                        album.closed.toggle()
                        update()
                    }

                    Button("Delete this album") {
                        showingDeleteConfirm.toggle()
                    }
                    .accentColor(.red)
                }
            }
            .listStyle(.insetGrouped)
            // overlay
            .navigationTitle("Edit Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundColor(.appColor)
                    }

                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        update()
                        self.presentationMode.wrappedValue.dismiss()
                        addItem(to: album)
                    } label: {
                        Text("Save")
                            .foregroundColor(.appColor)

                    }
                }
            }
            .alert(isPresented: $showingDeleteConfirm) {
                Alert(
                    title: Text("Delete album?"),
                    message: Text("Are you sure you want to delete this album? You will also delete all the items it contains."), // swiftlint:disable:this line_length
                    primaryButton: .destructive(Text("Delete"), action: delete),
                    secondaryButton: .cancel()
                )
            }
            .confirmationDialog("Pick your picture source", isPresented: $showConfirmationDialog) {
                Button("Library") {
                    // open photo library
                    self.pickerSourceType = .photoLibrary
                    self.showImagePicker = true
                }
                Button("Camera") {
                    // open camera app
                    self.pickerSourceType = .camera
                    self.showImagePicker = true
                    self.locationFetcher.start()
                }
            }
            .sheet(isPresented: $showImagePicker, onDismiss: addImage) {
                // imagePicker iOS13 for the album picture
                ImagePicker(image: self.$inputImage, pickerSourceType: self.pickerSourceType)
            }
            .sheet(isPresented: $showMultipleImagePicker, onDismiss: startLoadingScreen) {
                CustomPhotoPickerView(
                    mediaItems: $pickedImages,
                    actualImportStatus: $actualImportStatus,
                    amountOfPickedItems: $amountOfPickedItems
                )
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
            }
        }
    }

    func startLoadingScreen() {
        /// set to default setting again to reset the ZStack "opacity modifier" of the LoadingScreen View
        showLoadingScreen = false
        /// toggle to load loadingScreen
        showLoadingScreen.toggle()
    }

    func addImage() {
        guard let inputImage = inputImage else { return }
        convertedInputImage = Image(uiImage: inputImage)
    }

    func addItem(to project: Album) {
        /// tell the app that this task can run in the background
        DispatchQueue.main.async {
            /// Iterating over the Array 'selectedImage' since the imageData takes the longest to import into CoreData
            // for index in selectedImage.indices {

            /// test with the combined array
            for result in pickedImages {
                /// add new Item to CoreData
                let item = Item(context: managedObjectContext)

                /// tell the item to which project it belongs
                item.album = project

                /// saves the import data as its own property to use it in a later feature
                item.importDate = Date()

                /// every meta data with own array to improve the performance while fetching informations
                // item.creationDate = date[index]
                // item.latitude = location[index]?.latitude ?? region.center.latitude
                // item.longitude = location[index]?.longitude ?? region.center.longitude
                // item.mediaData = selectedImage[index]?.jpegData(compressionQuality: 0.8)

                /// test with an implementation of own combined array
                item.creationDate = result.creationDate
                item.latitude = result.location?.latitude ?? region.center.latitude
                item.longitude = result.location?.longitude ?? region.center.longitude
                item.mediaData = result.selectedImage?.jpegData(compressionQuality: 0.8)
            }
            /// save all the new added items to CoreData
            // dataController.save()
        }
    }

    func update() {
        // without this if clause the cover photo would get
        // deleted after resaving the album without a
        // selection of an image
        if inputImage != nil {
            album.coverImage = inputImage?.jpegData(compressionQuality: 0.5)
        }
        album.title = title
        album.detail = detail
        album.color = color
        album.startDate = startDate
        album.endDate = endDate

        // Debug only
        // print("\(album.coverImage)")
        // print("\(album.title)")
        // print("\(album.detail)")
        // print("\(album.color)")
        // print("\(album.startDate)")
        // print("\(album.endDate)")

        dataController.save()
    }

    func delete() {
        dataController.delete(album)
        presentationMode.wrappedValue.dismiss()
    }

    func deletePhoto(at index: Int) {
        pickedImages.remove(at: index)
        print(pickedImages.count)

        // DEBUG ONLY
        print("\(index) tapped")
        print("index in delete \(index)")
        print("image at \(index) deleted")
    }

    func colorButton(for item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)

            if item == color {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            color = item
            update()
        }
        // Step 1: VoiceOver help to read out all the possible languages
        .accessibilityElement(children: .ignore)
        // Step 2
        .accessibilityAddTraits(
            item == color
                ? [.isButton, .isSelected]
                : .isButton
        )
        // Step 3
        .accessibilityLabel(LocalizedStringKey(item))
    }
}

struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditAlbumView(project: Album.example)
    }
}
