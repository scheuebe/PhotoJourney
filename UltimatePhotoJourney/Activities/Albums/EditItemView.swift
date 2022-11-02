//
//  EditItemView.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 11.01.22.
//

import SwiftUI

struct EditItemView: View {
    let item: Item

    @EnvironmentObject var dataController: DataController

    @State private var title: String
    @State private var detail: String
    @State private var priority: Int
    @State private var completed: Bool

    // not 100% sure why we have to use that here
    init(item: Item) {
        self.item = item

        _title = State(wrappedValue: item.itemTitle)
        _detail = State(wrappedValue: item.itemDetail)
        _priority = State(wrappedValue: Int(item.priority))
        _completed = State(wrappedValue: item.completed)
    }

    var body: some View {
        Form {
            Section(header: Text("Photo")) {
                if item.mediaData != nil {
                    Image(uiImage: UIImage(data: item.mediaData!) ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150, alignment: .center)
                }
            }

            Section(header: Text("Metadata")) {
                Text("Latitude \(item.itemLatitude)")
                Text("Longitude \(item.itemLongitude)")
                Text("Creation Date \(item.itemCreationDate)")
                Text("Import date \(item.itemImportDate)")
            }

            Section(header: Text("Basic settings")) {
                TextField("Item name", text: $title.onChange(update))
                TextField("Description", text: $detail.onChange(update))
            }

            Section(header: Text("Priority")) {
                Picker("Priority", selection: $priority.onChange(update)) {
                    Text("Low").tag(1)
                    Text("Medium").tag(2)
                    Text("High").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section {
                Toggle("Mark Completed", isOn: $completed.onChange(update))
            }
        }
        .navigationTitle("Edit Item")
        .onDisappear(perform: dataController.save)
    }

    func update() {
        item.album?.objectWillChange.send()

        item.title = title
        item.detail = detail
        item.priority = Int16(priority)
        item.completed = completed
    }
}

struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView(item: Item.example)
    }
}
