//
//  ItemRowView.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 11.01.22.
//

import SwiftUI

struct ItemRowView: View {
    @StateObject var viewModel: ViewModel

    // just a reference to another owner and just watching for changes
    @ObservedObject var item: Item

    var body: some View {
        NavigationLink(destination: EditItemView(item: item)) {
            Label {
                HStack {
                    VStack {
                        Text(item.itemTitle)
                    }

                    if item.mediaData != nil {
                        Image(uiImage: UIImage(data: item.mediaData!) ?? UIImage())
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60, alignment: .center)
                    }

                    VStack {
                        Text("\(item.latitude)")
                        Text("\(item.longitude)")
                    }

                    if item.creationDate != nil {
                        Text(item.creationDate!.formatted(date: .long, time: .omitted))
                    }
                }
            } icon: {
                Image(systemName: viewModel.icon)
                    .foregroundColor(viewModel.color.map { Color($0) } ?? .clear)
            }
        }
        .accessibilityLabel(viewModel.label)
    }

    init(album: Album, item: Item) {
        let viewModel = ViewModel(album: album, item: item)
        _viewModel = StateObject(wrappedValue: viewModel)

        self.item = item
    }
}

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(album: Album.example, item: Item.example)
    }
}
