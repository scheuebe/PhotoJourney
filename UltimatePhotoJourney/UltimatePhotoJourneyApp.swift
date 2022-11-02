//
//  UltimatePhotoJourneyApp.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 17.01.22.
//
// Testflight / AppStore Connect Workflow
// https://www.ralfebert.de/ios/app-im-app-store-veroeffentlichen/

import SwiftUI

@main
struct UltimatePhotoJourneyApp: App {
    // StateObject owns the object
    @StateObject var dataController: DataController
    /// for custom navBar
    @StateObject var navigationModel = NavigationModel()
    /// WEATHER API
    // @StateObject var weatherController = WeatherObjectController.shared
    var downloadManager = DownloadManager.shared

    // initializer to be able to use different StateObjects throughout the whole app
    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                // make CoreData able to read values
                .environment(\.managedObjectContext, dataController.container.viewContext)
                // own code able to read CoreData values
                .environmentObject(dataController)
                .environmentObject(navigationModel)
                .environmentObject(downloadManager)
                .onReceive(
                    // Automatically save when we detect that we are no longer
                    // in the foreground app. Use this rather than the scene phase
                    // API so we can port to macOS, where scene phase won't detect
                    // our app losing focus as of macOS 11.1.x
                    NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification),
                    perform: save
                )
        }
    }

    func save(_ note: Notification) {
        dataController.save()
    }
}
