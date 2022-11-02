//
//  EditAlbumView.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 11.01.22.
//

import SwiftUI
import MapKit
import PhotosUI

struct EditAlbumView: View {
    @ObservedObject var album: Album

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

    init(album: Album) {
        self.album = album

        _title = State(wrappedValue: album.albumTitle)
        _detail = State(wrappedValue: album.albumDetail)
        _color = State(wrappedValue: album.albumColor)
        _startDate = State(wrappedValue: album.albumStartDate)
        _endDate = State(wrappedValue: album.albumEndDate)
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
                        TextField("Album name", text: $title)
                    }
                    HStack {
                        Image(systemName: "location")
                            .padding(.trailing, 10)
                            .padding(.vertical, 10)
                            .foregroundColor(.appColor)
                        TextField("Location", text: $detail)
                    }
                }

                Section(header: Text("Date")) {
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
                        /*.onChange(of: startDate, perform: { index in
                            if Calendar.current.isDate(endDate, equalTo: Date.now, toGranularity: .day)  {
                                endDate = startDate.addingTimeInterval(86400)
                            }
                        })*/
                    }
                }

                /*
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
                 */

                    /*
                    // Button to add new memories
                    Button {
                        withAnimation {
                            addItem(to: album)
                        }
                    } label: {
                        Label("Add New Item", systemImage: "plus")
                            .foregroundColor(Color(album.albumColor))
                    }
                     */

                    // Grid of saved items
                    /*if !album.albumItems.isEmpty {
                        LazyVGrid(columns: [
                            GridItem(.adaptive(minimum: 100), spacing: 5)], spacing: 5) {
                                ForEach(album.albumItems) { item in
                                    ItemRowView(album: album, item: item)
                                }
                            }
                    } else {
                        LazyVGrid(columns: [
                            GridItem(.adaptive(minimum: 100, maximum: 100), spacing: 5)], spacing: 5) {
                                ForEach(album.albumItemsDefaultSorted.indices, id: \.self) { index in
                                    VStack {
                                        Image(uiImage: UIImage(data: album.albumItemsDefaultSorted[index].mediaData!) ?? UIImage())
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    }

                                        .frame(width: 100, height: 100, alignment: .center)
                                        .clipped()
                                        .cornerRadius(4)
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
                                                            deleteItem(at: index, from: album)
                                        }
                                }
                            // }
                    }
                }*/

                Section(
                    header: Text("Custom Tag Color"),
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
                        }
                        Spacer()
                    },
                    content: {
                    LazyVGrid(columns: colorColumns) {
                        ForEach(Album.colors, id: \.self) { item in
                            colorButton(for: item)
                        }
                    }
                    .padding(.vertical)
                })

                /*

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
                 */
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Edit Album")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        cancel()
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
        }
    }

    func addImage() {
        guard let inputImage = inputImage else { return }
        convertedInputImage = Image(uiImage: inputImage)
    }

    func update() {
        // without this if clause the cover photo would get
        // deleted after resaving the album without a
        // selection of an image
        if inputImage != nil {
            album.coverImage = inputImage?.jpegData(compressionQuality: 0.8)
        }
        
        album.title = title
        album.detail = detail
        album.color = color
        album.startDate = startDate
        album.endDate = endDate
        album.show = false
        dataController.save()
    }

    func cancel() {
        /// deletes album if no changes to the initialised album are made
        if inputImage == nil && album.coverImage == nil && title == "New Album" && detail == "" {
            dataController.delete(album)
            presentationMode.wrappedValue.dismiss()
        }
    }

    func delete() {
        dataController.delete(album)
        presentationMode.wrappedValue.dismiss()
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

struct EditAlbumView_Previews: PreviewProvider {
    static var previews: some View {
        EditAlbumView(album: Album.example)
    }
}
