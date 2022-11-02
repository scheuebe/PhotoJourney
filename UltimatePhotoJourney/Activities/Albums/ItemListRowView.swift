//
//  ItemListRowView.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 13.01.22.
//

import SwiftUI

struct ItemListRowView: View {
    let item: Item

    var body: some View {
        VStack(alignment: .leading) {
            Text(item.itemTitle)
                .font(.title2)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)

            if item.itemDetail.isEmpty == false {
                Text(item.itemDetail)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct ItemListRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListRowView(item: Item.example)
    }
}
