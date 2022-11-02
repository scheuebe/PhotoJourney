//
//  Album-CoreDataHelpers.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 11.01.22.
//

import Foundation
import SwiftUI

// helper to get optionals from CoreData without having to type it all the time inside of the normal code
// just getter no setter

extension Album {
    static let colors = [
        "Light Yellow",
        "Gold",
        "Light Orange",
        "Orange",
        "Red",
        "Dark Brown",
        "Taupe",
        "Pink",
        "Purple",
        "Green",
        "Dark Green",
        "Teal",
        "Light Blue",
        "Dark Blue",
        "Midnight",
        "Gray",
        "Dark Gray",
        "Black"
    ]

    var albumTitle: String {
        title ?? NSLocalizedString("New Album", comment: "Create a new album")
    }

    var albumDetail: String {
        detail ?? ""
    }

    var albumColor: String {
        color ?? "Light Orange"
    }

    var albumStartDate: Date {
        startDate ?? Date()
    }

    var albumEndDate: Date {
        endDate ?? Date()
    }

    var albumItems: [Item] {
        // avoid the transformation from NSSet to Array of Any with typecasting to the specific Object
        items?.allObjects as? [Item] ?? []
    }

    var albumItemsDefaultSorted: [Item] {
        // sort array for completed or not completed with the ascending creation date
        albumItems.sorted { first, second in
            if first.completed == false {
                if second.completed == true {
                    return true
                }
            } else if first.completed == true {
                if second.completed == false {
                    return false
                }
            }

            if first.priority > second.priority {
                return true
            } else if first.priority < second.priority {
                return false
            }

            return first.itemCreationDate > second.itemCreationDate
        }
    }
    
    var albumItemsCreationDateAscending: [Item] {
        albumItems.sorted { first, second in
            return first.itemCreationDate < second.itemCreationDate
        }
    }

    //
    var completionAmount: Double {
        let originalItems = items?.allObjects as? [Item] ?? []
        guard originalItems.isEmpty == false else { return 0 }

        let completedItems = originalItems.filter(\.completed)
        return Double(completedItems.count) / Double(originalItems.count)
    }

    var itemsCount: Int {
        let allItems = items?.allObjects as? [Item] ?? []
        guard allItems.isEmpty == false else { return 0 }

        return allItems.count
    }

    var label: LocalizedStringKey {
        // swiftlint:disable:next line_length
        LocalizedStringKey("\(albumTitle), \(albumItems.count) items, \(completionAmount * 100, specifier: "%g")% complete.")
    }

    static var example: Album {
        let controller = DataController.preview
        let viewContext = controller.container.viewContext

        let album = Album(context: viewContext)
        album.title = "Album"
        album.detail = "This is an example album"
        album.closed = true
        album.creationDate = Date()
        album.startDate = Date()
        album.endDate = Date()

        return album
    }

    func albumItems(using sortOrder: Item.SortOrder) -> [Item] {
        switch sortOrder {
        case .title:
            return albumItems.sorted(by: \Item.itemTitle)
        case .creationDate:
            return albumItems.sorted(by: \Item.itemCreationDate)
        case .optimized:
            return albumItemsDefaultSorted
        }
    }
}
