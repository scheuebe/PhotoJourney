//
//  ItemRowViewModel.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 15.01.22.
//

import Foundation

extension ItemRowView {
    class ViewModel: ObservableObject {
        let album: Album
        let item: Item

        var title: String {
            item.itemTitle
        }

        var icon: String {
            if item.completed {
                return "checkmark.circle"
            } else if item.priority == 3 {
                return "exclamationmark.triangle"
            } else {
                return "checkmark.circle"
            }
        }

        var color: String? {
            if item.completed {
                return album.albumColor
            } else if item.priority == 3 {
                return album.albumColor
            } else {
                return nil
            }
        }

        var label: String {
            if item.completed {
                return "\(item.itemTitle), completed"
            } else if item.priority == 3 {
                return "\(item.itemTitle), high priority"
            } else {
                return item.itemTitle
            }
        }

        init(album: Album, item: Item) {
            self.album = album
            self.item = item
        }
    }
}
