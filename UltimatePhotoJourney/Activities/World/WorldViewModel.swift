//
//  WorldViewModel.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 11.02.22.
//

import CoreData
import Foundation
import MapKit

extension WorldView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        private let albumController: NSFetchedResultsController<Album>
        private let itemsController: NSFetchedResultsController<Item>

        @Published var mapRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 50,
                longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 60))

        @Published var albums = [Album]()
        @Published var items = [Item]()
        @Published var selectedPlace: Item?

        let dataController: DataController

        init(dataController: DataController) {
            self.dataController = dataController

            // Construct a fetch request to show all open albums
            let albumRequest: NSFetchRequest<Album> = Album.fetchRequest()
            albumRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Album.title, ascending: true)]

            albumController = NSFetchedResultsController(
                fetchRequest: albumRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            let itemRequest: NSFetchRequest<Item> = Item.fetchRequest()
            itemRequest.sortDescriptors = [
                NSSortDescriptor(keyPath: \Item.creationDate, ascending: false)
            ]
            // itemRequest.fetchLimit = 10

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
    }
}
