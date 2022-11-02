//
//  Item-CoreDataHelpers.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 11.01.22.
//

import Foundation

// helper to avoid optionals in code
// just a getter to retrieve the values

extension Item {
    enum SortOrder {
        case optimized, title, creationDate
    }

    var itemTitle: String {
        title ?? NSLocalizedString("New Item", comment: "Create a new item")
    }

    var itemDetail: String {
        detail ?? ""
    }
    
    var itemSoundResult: Int {
        Int(soundResult)
    }

    var itemCreationDate: Date {
        creationDate ?? Date()
    }

    var itemAPIFormattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"

        return dateFormatter.string(from: creationDate ?? Date.now)
    }

    var itemImportDate: Date {
        importDate ?? Date()
    }

    var itemLatitude: Double {
        latitude
    }

    var itemLongitude: Double {
        longitude
    }

    static var example: Item {
        let controller = DataController.preview
        let viewContext = controller.container.viewContext

        let item = Item(context: viewContext)
        item.title = "Example Item"
        item.detail = "This is an example item"
        item.priority = 3
        item.importDate = Date()

        return item
    }
}
