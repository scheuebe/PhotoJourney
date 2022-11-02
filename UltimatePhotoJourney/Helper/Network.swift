//
//  Network.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 19.09.22.
//

import Foundation
import Network

class Network: ObservableObject {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    @Published private(set) var connected: Bool = false
    
    func checkConnection() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.connected = true
            } else {
                self.connected = false
            }
        }
        monitor.start(queue: queue)
    }
}

// MARK: implementation inside the view
/*
 @StateObject var network = Network()
 
 var body: some View {
    Text("We are \(network.connected ? "connected" : "not connected") to the internet."")
 }
 */
