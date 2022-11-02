//
//  ImageObjectControllers.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 15.09.22.
//

import Foundation
import SwiftUI

class ImageObjectController: ObservableObject {
    @AppStorage("tokenID") var tokenID: Int = 0
    static let shared = ImageObjectController()
    private init() {
        
    }
    
    // to generate enough pictures without the fetchRequest
    var token = [
        "Br2eHqwU2pfoeIvzfxCvT5gTyxuJIVpK9ttkVqrYMx8",
        "QD6VqTqC58GsjNc3ODu0ToFs8Cw22HJW9otPz_LRXcs",
        "TuuiVROvNwTfRHD47oyo8XMNmP-uKDwB-JL0XiyhhX4",
        "ItY24Zh-c17MZl0G_gdktCrkqWGsT9D7PWB8qtqTMkA",
        "BZxGVDErik1PJJH5z-kw-hgaHybqhYKcHzU4BrK8WXM",
        "WBGq68CiYhpXEg192e_L85kseJbIVSH3vB3IPYkK0n8",
        "W7tPcpN-dASmK8wN2C--X-bwUUkrv-0bkGdvdIiImFo",
        "U7l0PO0y_WnDsE5AJj9PTiwc8XVqXz65l66XqtnX2Pk",
        "9QJuJBr6rFRjRbp1U0IzuNeR-5j1yGxQcL7xV_SDvvo",
        "9dn9PikHEFugvcrpDk3LbWyKFiCtsl6lIH1kAbV2API"
    ]
    var token0 = "Br2eHqwU2pfoeIvzfxCvT5gTyxuJIVpK9ttkVqrYMx8"
    var token1 = "QD6VqTqC58GsjNc3ODu0ToFs8Cw22HJW9otPz_LRXcs"
    var token2 = "TuuiVROvNwTfRHD47oyo8XMNmP-uKDwB-JL0XiyhhX4"
    var token3 = "ItY24Zh-c17MZl0G_gdktCrkqWGsT9D7PWB8qtqTMkA"
    var token4 = "BZxGVDErik1PJJH5z-kw-hgaHybqhYKcHzU4BrK8WXM"
    var token5 = "WBGq68CiYhpXEg192e_L85kseJbIVSH3vB3IPYkK0n8"
    var token6 = "W7tPcpN-dASmK8wN2C--X-bwUUkrv-0bkGdvdIiImFo"
    var token7 = "U7l0PO0y_WnDsE5AJj9PTiwc8XVqXz65l66XqtnX2Pk"
    var token8 = "9QJuJBr6rFRjRbp1U0IzuNeR-5j1yGxQcL7xV_SDvvo"
    var token9 = "9dn9PikHEFugvcrpDk3LbWyKFiCtsl6lIH1kAbV2API"
    
    @Published var imageResults = [ImageResult]()
    @Published var query: String = "wallpaper"
    @Published var value: Double = 0.0
    @Published var distributionResult: String = ""
    
    func getDistribution() -> String {
        self.value = Double.random(in: 0...1)
        if value < 0.1483 {
            distributionResult = "people"
        } else if value < 0.2792 {
            distributionResult = "holiday"
        } else if value < 0.4101 {
            distributionResult = "event"
        } else if value < 0.5342 {
            distributionResult = "landscape"
        } else if value < 0.6444 {
            distributionResult = "animal"
        } else if value < 0.7271 {
            distributionResult = "building"
        } else if value < 0.8043 {
            distributionResult = "shopping"
        } else if value < 0.8787 {
            distributionResult = "food"
        } else if value < 0.9476 {
            distributionResult = "flowers"
        } else {
            distributionResult = "other"
        }
        
        print("\(distributionResult): \(value)")
        
        if distributionResult != "other" {
            let searchQuery = "query=\(distributionResult)&"
            query = searchQuery
        } else {
            query = ""
        }
        
        return query
    }
    
    /*
    func search() {
        guard let url = URL(string: "https://api.unsplash.com/photos/random/?\(query)client_id=\(token[tokenID])") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // request.setValue("Client-ID \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let data = data, error == nil else { return }
            
            do {
                let jsonResult = try JSONDecoder().decode(ImageResult.self, from: data)
                DispatchQueue.main.async {
                    // self?.imageResults.append(contentsOf: jsonResult.imageResults)
                    self?.imageResult.append(jsonResult)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    */
    
    private func buildURLRequest(query: String) ->
        URLRequest {
        let url = URL(string: "https://api.unsplash.com/photos/random/?\(query)client_id=\(token[tokenID])")!
        print(url)
        var request = URLRequest(url: url)
        return request
    }
    
    func asyncSearch() async -> ImageResult {
        let distribution = getDistribution()
        let request = buildURLRequest(query: query)
        
        print(request)
        
        do {
          let (data, response) = try await URLSession.shared.data(for: request)
          guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw fatalError()
          }
            let imageResult = try JSONDecoder().decode(ImageResult.self, from: data)
            // imageResult.append(jsonResult)
            // print(imageResult)
            // print(imageResult.count)
            return imageResult
        }
        catch {
            print(error)
            return ImageResult.empty
            
        }
    }
}
