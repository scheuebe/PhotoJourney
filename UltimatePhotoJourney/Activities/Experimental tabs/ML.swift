//
//  ML.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 13.07.22.
//
//  missing feature:    - after change of picture -> stop sound
//                      - complete implementation of ImagePredictor Model

import SwiftUI
import AVFoundation

struct ML: View {
    // sound API
    @State var soundObjectController = SoundObjectController.shared
    @State var soundList = SoundList.empty
    @State var isPlaying: Bool = false
    @State var isSearching: Bool = true
    @State var playSoundIndex: Int = 0
    
    // configuration of own tab
    static let tag: String? = "ML"
    
    // part of the ML
    let model = MobileNetV2()
    @State private var predictsToShow: Int = 1
    @State private var song = ""
    @State private var classificationLabel: String = ""
    
    // for tabView
    @State private var indexCurrentItem: Int = 1
    
    // to play audio effects
    @State var audioPlayer: AVPlayer?
    
    // @ObservedObject var album: Album
    // to toggle global tab- and navBar
    @EnvironmentObject var navigationModel: NavigationModel
    
    var body: some View {
        GeometryReader { geo in
            TabView(selection: $indexCurrentItem) {
                ForEach(1...9, id: \.self) { index in
                    VStack {
                        Image("tomorrowland-\(index)")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width, height: geo.size.height+100)
                            .clipped()
                            .overlay(
                                VStack {
                                    Spacer()
                                    
                                    HStack {
                                        if isSearching {
                                            ProgressView()
                                                .scaleEffect(1.25)
                                                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                                                .frame(height: 40, alignment: .center)
                                        } else {
                                            Button {
                                                if audioPlayer?.rate != 0 && audioPlayer?.error == nil {
                                                    self.isPlaying = false
                                                    self.audioPlayer?.pause()
                                                } else {
                                                    self.isPlaying = true
                                                    self.audioPlayer?.play()
                                                }
                                            } label: {
                                                Image(systemName: self.isPlaying ? "pause.circle" : "play.circle")
                                                    .font(.system(size: 35))
                                            }
                                            
                                            Button {
                                                audioPlayer?.pause()
                                                
                                                if playSoundIndex < 10 {
                                                    playSoundIndex = playSoundIndex + 1
                                                }
                                                if playSoundIndex == 9 {
                                                    playSoundIndex = 0
                                                }
                                                
                                                playSounds(url: soundList.results[playSoundIndex].previews.preview_lq_mp3)
                                            } label: {
                                                Image(systemName: "shuffle.circle.fill")
                                                    .font(.system(size: 35))
                                            }
                                        }
                                        
                                    }
                                        
                                    
                                    
                                    Spacer()
                                    
                                    // Divider()
                                    //    .overlay(Color.white)
                                    
                                    // Spacer()
                                    
                                    Text(classificationLabel)
                                        .multilineTextAlignment(.center)
                                        .font(.body)
                                    
                                    Spacer()
                                }
                                    .frame(width: geo.size.width, height: 100)
                                    .foregroundColor(.white)
                                    .background(BlurView(style: .systemUltraThinMaterialDark))
                                    .backgroundStyle(cornerRadius: 14, opacity: 0.4)
                                    .scaleEffect(0.9)
                                    .offset(y: -100),
                                alignment: .bottom
                            )
                        
                        Spacer()
                    }
                    .tag(index)
                }
                .task(id: indexCurrentItem) {
                    self.classificationLabel = await classifyImageWithAsync()
                    await callSoundAPI(classificationResult: classificationLabel)
                    playSounds(url: soundList.results[playSoundIndex].previews.preview_lq_mp3)
                    isSearching = false
                }
                .onDisappear {
                    isSearching = true
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .onChange(of: indexCurrentItem, perform: { index in
                isSearching = true
                self.audioPlayer?.pause()
                self.song = ""
                self.classificationLabel = ""
                self.playSoundIndex = 0
            })
            .onDisappear {
                self.audioPlayer?.pause()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .statusBar(hidden: true)
    }
    
    func startSound() async {
        self.classificationLabel = await classifyImageWithAsync()
        await callSoundAPI(classificationResult: classificationLabel)
        isSearching = false
    }
    
    var soundAPI: some View {
        VStack(alignment: .leading) {
            if isSearching {
                ProgressView()
            } else {
                VStack(alignment: .leading) {
                    Text("API response:")
                        .font(.title)
                    Text("Anzahl Ergebnisse \(soundList.count)")
                    Text("Next \(soundList.next)")
                    List {
                        ForEach(soundList.results) { result in
                            HStack {
                                Button {
                                    playSounds(url: result.previews.preview_lq_mp3)
                                } label: {
                                    Image(systemName: "play.circle")
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("ID: \(result.id)")
                                    Text("Name: \(result.name)")
                                    Text("Description: \(result.description)")
                                    Text("Duration: \(result.duration)")
                                    Text("Number of downloads: \(result.num_downloads)")
                                    Text("Avg rating: \(result.avg_rating)")
                                    Text("Num ratings: \(result.num_ratings)")
                                    Text("Preview String: \(result.previews.preview_lq_mp3)")
                                }
                            }
                        }
                    }
                }
            }
        }
        .task(id: indexCurrentItem) {
            let apiSoundList = await soundObjectController.search()
            soundList = apiSoundList
            isSearching = false
        }
        .onDisappear {
            isSearching = true
        }
    }
    
    private func classifyImage() {
        let currentImageName = "tomorrowland-\(indexCurrentItem)"
        
        guard let image = UIImage(named: currentImageName),
              let resizedImage = image.resizeImageTo(size:CGSize(width: 224, height: 224)),
              let buffer = resizedImage.convertToBuffer() else {
              return
        }
        
        let output = try? model.prediction(image: buffer)
        
        if let output = output {
            let results = output.classLabelProbs.sorted { $0.1 > $1.1 }
            let result = results.prefix(predictsToShow).map { (key, value) in
                let formattedResultOfClassification = formatClassificationResultToStringForAPI(input: key)
                self.song = formattedResultOfClassification[0]
                print("Variable song: \(song)")
                return "\(key) = \(String(format: "%.2f", value * 100))%"
            }.joined(separator: "\n")

            self.classificationLabel = result
        }
    }
    
    private func stopAudio() {
        self.audioPlayer?.pause()
    }
    
    func callSoundAPI(classificationResult: String) async {
        soundObjectController.queryString = song.replacingOccurrences(of: " ", with: "%20")
        let apiSoundList = await soundObjectController.search()
        soundList = apiSoundList
        // print(soundList)
        /*NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: audioPlayer?.currentItem, queue: .main, using: playerDidFinishPlaying)*/
        isSearching = false
    }
    
    func playerDidFinishPlaying(notification: Notification) {
        isPlaying = false
        self.audioPlayer?.seek(to: CMTime(seconds: 0.0, preferredTimescale: 1))
        NotificationCenter.default.removeObserver(self)
    }
    
    func playSounds(url: String) {
        guard let soundURL = URL(string: url) else {
            fatalError()
        }
        
        do {
            audioPlayer = try AVPlayer(url: soundURL)
        } catch {
            print(error)
        }
        isPlaying = true
        audioPlayer?.play()
    }
    
    func formatClassificationResultToStringForAPI(input: String) -> [String] {
        var cutResults = input.components(separatedBy: CharacterSet(charactersIn: ","))
        print("vor der Formatierung: \(cutResults)")
        
        for i in cutResults.indices {
            let str = cutResults[i].trimmingCharacters(in: .whitespacesAndNewlines)
            cutResults[i] = str
        }
        
        print("Nach der Formatierung: \(cutResults)")
        return cutResults
    }

    private func classifyImageWithAsync() async -> String {
        let currentImageName = "tomorrowland-\(indexCurrentItem)"
        
        guard let image = UIImage(named: currentImageName),
              let resizedImage = image.resizeImageTo(size:CGSize(width: 224, height: 224)),
              let buffer = resizedImage.convertToBuffer() else {
              return ""
        }
        
        let output = try? model.prediction(image: buffer)
        
        if let output = output {
            let results = output.classLabelProbs.sorted { $0.1 > $1.1 }
            let result = results.prefix(predictsToShow).map { (key, value) in
                let formattedResultOfClassification = formatClassificationResultToStringForAPI(input: key)
                self.song = formattedResultOfClassification[0]
                print("Variable song: \(song)")
                return "\(key) = \(String(format: "%.2f", value * 100))%"
            }.joined(separator: "\n")

            return result
        }
        return ""
    }
}

/*
struct ML_Previews: PreviewProvider {
    static var previews: some View {
        ML()
    }
}
 */
