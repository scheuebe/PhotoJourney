//
//  HomeView.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 10.01.22.
//

import CoreData
import SwiftUI

struct HomeView: View {
    // for easy storing of the user navigation
    // should be optional since String? & String don't have the same hash values
    static let tag: String? = "Home"
    @StateObject var viewModel: ViewModel

    var albumRow: [GridItem] {
        [GridItem(.fixed(100))]
    }

    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        // NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: albumRow) {
                            ForEach(viewModel.albums) { album in
                                AlbumSummaryView(album: album)
                            }
                        }
                        .padding([.horizontal, .top])
                        .fixedSize(horizontal: false, vertical: true)
                    }

                    VStack(alignment: .leading) {
                        Text("Album: \(viewModel.albums.count)")
                        ItemListView(title: "Up next", items: viewModel.upNext)
                        ItemListView(title: "More to explore", items: viewModel.moreToExplore)
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Debug menu")
            .toolbar {
                Button("Add data", action: viewModel.addSampleData)
            }
        // }
    }
}

/*
 Button("Add data") {
     dataController.deleteAll()
     try? dataController.createSampleData()
 }
 */

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(dataController: DataController.preview)
    }
}
