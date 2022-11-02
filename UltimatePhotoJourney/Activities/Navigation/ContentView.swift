//
//  ContentView.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 17.01.22.
//

import SwiftUI

struct ContentView: View {
    // to save the last used tab of the user
    // use of SceneStorage to avoid the tab being synchronized on two scenes on bigger screens
    @SceneStorage("selectedView") var selectedView: Tab = .albums
    @EnvironmentObject var dataController: DataController

    var body: some View {
        ZStack {
            Group {
                switch selectedView {
                case .albums:
                    AlbumView(dataController: dataController, showClosedAlbums: false)
                        .tag(AlbumView.openTag)
                        .tabItem {
                            Image(systemName: "list.bullet")
                            Text("Open")
                        }
                case .world:
                    WorldView(dataController: dataController)
                        .tag(WorldView.tag)
                        .tabItem {
                            Image(systemName: "checkmark")
                            Text("Closed")
                        }
                /*
                case .ml:
                    ML()
                        .tag(ML.tag)
                        .tabItem {
                            Image(systemName: "photo")
                            Text("ML")
                        }
                 */
                    
                case .me:
                    MeView()
                        .tag(MeView.tag)
                        .tabItem {
                            Image(systemName: "rosette")
                            Text("Awards")
                        }
                case .settings:
                    SettingsView(dataController: dataController)
                        .tag(SettingsView.tag)
                        .tabItem {
                            Image(systemName: "house")
                            Text("World")
                        }
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack {}.frame(height: 44)
            }

            TabBar()
                .zIndex(0)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        ContentView()
        .environment(\.managedObjectContext, dataController.container.viewContext)
        .environmentObject(dataController)
    }
}
