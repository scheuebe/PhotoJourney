//
//  PickedMediaItem.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 18.01.22.
//

import Foundation
import CoreLocation
import SwiftUI

struct PickedMediaItem: Identifiable {
    var id = UUID()
    var selectedImage: UIImage?
    var creationDate: Date?
    var location: CLLocationCoordinate2D?
}

class PickedMediaItems: ObservableObject {
    @Published var pickedItems = [PickedMediaItem]()

    func append(item: PickedMediaItem) {
        pickedItems.append(item)
    }

/*
    func deleteAll() {
        for (index, _) in pickedItems.enumerated() {
            pickedItems[index].delete()
        }

        pickedItems.removeAll()
    }
 */
}
