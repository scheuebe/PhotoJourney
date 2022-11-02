//
//  ItemListView.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 13.01.22.
//

import SwiftUI

struct ItemListView: View {
    let title: LocalizedStringKey
    let items: ArraySlice<Item>

    var body: some View {
        if items.isEmpty {
            EmptyView()
        } else {
            // Image(uiImage: UIImage(data: items))

            Text("Entry")
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)

            ForEach(items) { item in
                NavigationLink(destination: EditItemView(item: item)) {
                    HStack(spacing: 20) {
                        Circle()
                            .stroke(Color(item.album?.albumColor ?? "Light Blue"), lineWidth: 3)
                            .frame(width: 44, height: 44)

                        ItemListRowView(item: item)
                    }
                    .padding()
                    .background(Color.secondarySystemGroupedBackground)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 5)
                }
            }
        }
    }
}

/*
 struct ItemListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListView()
    }
}
 */
