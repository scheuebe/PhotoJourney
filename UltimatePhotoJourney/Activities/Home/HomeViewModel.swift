//
//  HomeViewModel.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 15.01.22.
//

import CoreData
import Foundation

extension HomeView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        private let albumController: NSFetchedResultsController<Album>
        private let itemsController: NSFetchedResultsController<Item>

        @Published var albums = [Album]()
        @Published var items = [Item]()

        var dataController: DataController

        var upNext: ArraySlice<Item> {
            items.prefix(3)
        }

        var moreToExplore: ArraySlice<Item> {
            items.dropFirst(3)
        }

        init(dataController: DataController) {
            self.dataController = dataController

            // Construct a fetch request to show all open albums
            let albumRequest: NSFetchRequest<Album> = Album.fetchRequest()
            albumRequest.predicate = NSPredicate(format: "closed = false")
            albumRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Album.title, ascending: true)]

            albumController = NSFetchedResultsController(
                fetchRequest: albumRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            // Construct a fetch request to show the 10 highest-priority, incomplete items from open albums
            let itemRequest: NSFetchRequest<Item> = Item.fetchRequest()

            let completedPredicate = NSPredicate(format: "completed = false")
            let openPredicate = NSPredicate(format: "album.closed = false")
            let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])
            itemRequest.predicate = compoundPredicate

            itemRequest.sortDescriptors = [
                NSSortDescriptor(keyPath: \Item.priority, ascending: false)
            ]

            itemRequest.fetchLimit = 10

            itemsController = NSFetchedResultsController(
                fetchRequest: itemRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            super.init()

            albumController.delegate = self
            itemsController.delegate = self

            do {
                try albumController.performFetch()
                try itemsController.performFetch()
                albums = albumController.fetchedObjects ?? []
                items = itemsController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch initial data.")
            }
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newItems = controller.fetchedObjects as? [Item] {
                items = newItems
            } else if let newAlbums = controller.fetchedObjects as? [Album] {
                albums = newAlbums
            }
        }

        func addSampleData() {
            // dataController.deleteAll()
            try? dataController.createSampleData()
        }
    }
}
