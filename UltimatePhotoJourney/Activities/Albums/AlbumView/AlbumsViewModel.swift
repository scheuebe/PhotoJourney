//
//  AlbumssViewModel.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 15.01.22.
//

import CoreData
import Foundation

extension AlbumView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        let dataController: DataController

        var sortOrder = Item.SortOrder.optimized
        let showClosedAlbums: Bool

        private let albumsController: NSFetchedResultsController<Album>
        @Published var albums = [Album]()

        init(dataController: DataController, showClosedAlbums: Bool) {
            self.dataController = dataController
            self.showClosedAlbums = showClosedAlbums

            let request: NSFetchRequest<Album> = Album.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Album.creationDate, ascending: false)]
            request.predicate = NSPredicate(format: "closed = %d", showClosedAlbums)

            albumsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            super.init()
            albumsController.delegate = self

            do {
                try albumsController.performFetch()
                albums = albumsController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch our albums!")
            }

        }

        func addAlbum() -> Album {
            let album = Album(context: dataController.container.viewContext)
            album.closed = false
            album.creationDate = Date()
            dataController.save()

            return album
        }

        func addItem(to album: Album) {
            let item = Item(context: dataController.container.viewContext)
            item.album = album
            item.creationDate = Date()
            dataController.save()
        }

        func delete(_ offsets: IndexSet, from album: Album) {
            let allItems = album.albumItems(using: sortOrder)

            for offset in offsets {
                let item = allItems[offset]
                dataController.delete(item)
            }

            dataController.save()
        }
        
        var albumsSorted: [Album] {
            // albums.sorted
            /*albums.sorted { first, second in
                first.startDate ?? Date() < second.startDate ?? Date()
            }*/
            return albums.sorted(by: { $0.albumStartDate > $1.albumStartDate })
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newAlbums = controller.fetchedObjects as? [Album] {
                albums = newAlbums
            }
        }
    }
}
