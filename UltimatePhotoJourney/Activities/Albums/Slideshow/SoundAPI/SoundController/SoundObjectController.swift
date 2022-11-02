//
//  SoundObjectController.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 08.08.22.
//

import Foundation
import SwiftUI
// import AVFoundation

class SoundObjectController: ObservableObject {
    static let shared = SoundObjectController()
    private init() {
        
    }
    
    var token = "v9fmXW3JWHOIZYgln2yUlIoTOekUI2i9U9tsyjjB"
    @Published var queryString: String = "jeep"
    
    @Published var results = [SoundResult]()
    
    /* refactoring
    @Published var list: SoundList
    @Published var soundList = SoundList.empty
    @Published var soundResult = ""
    @Published var audioPlayer: AVPlayer?
    @Published var isPlaying: Bool = false
    @Published var isSearching: Bool = true
    @Published var playSoundIndex: Int = 0
     */
    
    private func buildURLRequest() -> URLRequest {
        let url = URL(string: "https://freesound.org/apiv2/search/text/?query=\(queryString)&fields=id,name,description,duration,previews,num_downloads,avg_rating,num_ratings&token=\(token)")!
        
        /// alternative query strings
        //  freesound.org/apiv2/search/text/?query=\(queryString)&sort=downloads_desc&token=\(token)
        //  freesound.org/apiv2/search/text/?query=\(queryString)&sort=rating_desc&token=\(token)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    private func alternativeSearchRequest() -> URLRequest {
        let url = URL(string: "https://freesound.org/apiv2/search/text/?query=\(queryString)&sort=rating_desc&token=\(token)")!
        
        /// alternative query strings
        //   freesound.org/apiv2/search/text/?query=\(queryString)&sort=downloads_desc&token=\(token)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    func search() async -> SoundList {
        let request = buildURLRequest()
        
        do {
          let (data, response) = try await URLSession.shared.data(for: request)
          guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw fatalError()
          }
            let soundList = try JSONDecoder().decode(SoundList.self, from: data)
            return soundList
        }
        catch {
            print(error)
            return SoundList.empty
        }
    }
    
    /*
    func alternativeSearch() {
        let url = URL(string: "https://freesound.org/apiv2/search/text/?query=\(queryString)&token=\(token)")!
        
        print(url)
        
        /// alternative query strings
        //  freesound.org/apiv2/search/text/?query=\(queryString)&sort=downloads_desc&token=\(token)
        //  freesound.org/apiv2/search/text/?query=\(queryString)&sort=rating_desc&token=\(token)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let soundList = try JSONDecoder().decode(SoundList.self, from: data)
                self.results.append(contentsOf: res.results)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
     */
    
    // Start of refactoring
    /*
    func controlAudioPlayer() {
        if audioPlayer?.rate != 0 && audioPlayer?.error == nil {
            self.isPlaying = false
            self.audioPlayer?.pause()
        } else {
            self.isPlaying = true
            self.audioPlayer?.play()
        }
    }
    
    func getSoundFromAPI(url: String) {
        guard let soundURL = URL(string: url) else {
            fatalError()
        }
        
        do {
            audioPlayer = try AVPlayer(url: soundURL)
        } catch {
            print(error)
        }
    }
    
    func getNextSoundFromAPI(soundList: SoundList) {
        audioPlayer?.pause()
        
        if playSoundIndex < 10 {
            playSoundIndex = playSoundIndex + 1
        }
        if playSoundIndex == 9 {
            playSoundIndex = 0
        }
        
        getSoundFromAPI(url: soundList.results[playSoundIndex].previews.preview_lq_mp3)
        isPlaying = true
        audioPlayer?.play()
    }
     */
}
