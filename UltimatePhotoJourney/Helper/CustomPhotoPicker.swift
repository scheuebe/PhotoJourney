//
//  PhotoPicker.swift
//  PhotoJourney
//
//  Created by Bernhard Scheuermann on 02.11.21.
//
//  help by appcoda.com/phpicker

import SwiftUI
import PhotosUI

struct CustomPhotoPickerView: UIViewControllerRepresentable {
    var album: Album

    @Binding var actualImportStatus: Int
    @Binding var amountOfPickedItems: Int

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        config.selectionLimit = 0
        config.preferredAssetRepresentationMode = .current

        let controller = PHPickerViewController(configuration: config)
        controller.delegate = context.coordinator
        return controller
    }

    func makeCoordinator() -> CustomPhotoPickerView.Coordinator {
        return Coordinator(self)
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    }

    class Coordinator: PHPickerViewControllerDelegate {
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            guard !results.isEmpty else {
                return
            }

            self.parent.amountOfPickedItems = 0
            self.parent.actualImportStatus = 0
            // self.parent.amountOfPickedItems = self.parent.album.itemsCount

            for result in results.indices {
                self.parent.amountOfPickedItems += 1
                print("\(self.parent.amountOfPickedItems)")

                let imageResult = results[result]
                var creationTimeMetaData: Date = Date()
                var locationMetaData: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)

                if let assetId = imageResult.assetIdentifier {
                    let assetResults = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
                    DispatchQueue.main.async {

                        /// creation time metadata
                        creationTimeMetaData = assetResults.firstObject?.creationDate ?? Date()

                        /// location metadata
                        if let location = assetResults.firstObject?.location?.coordinate {
                            locationMetaData = location
                        }

                        /// method to get the fetched image
                        if imageResult.itemProvider.canLoadObject(ofClass: UIImage.self) {
                            imageResult.itemProvider.loadObject(ofClass: UIImage.self) { (selectedImage, error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                } else {
                                    DispatchQueue.main.async {
                                        let rawImageData = selectedImage as? UIImage ?? UIImage()

                                        /// save import to CoreData
                                        let newItem = Item(context: self.parent.managedObjectContext)
                                        newItem.album = self.parent.album
                                        newItem.importDate = Date()
                                        newItem.creationDate = creationTimeMetaData
                                        newItem.latitude = locationMetaData.latitude
                                        newItem.longitude = locationMetaData.longitude
                                        newItem.mediaData = rawImageData.jpegData(compressionQuality: 0.8)

                                        self.parent.actualImportStatus += 1
                                        // self.parent.actualImportStatus = self.parent.album.itemsCount
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        private let parent: CustomPhotoPickerView
        init(_ parent: CustomPhotoPickerView) {
            self.parent = parent
        }
    }
}

/*
struct CustomPhotoPicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomPhotoPickerView(
            selectedImage: Binding.constant(nil),
            date: Binding.constant(nil),
            location: Binding.constant(CLLocationCoordinate2D(latitude: 2.0, longitude: 2.0)
        ))
    }
}
 */
