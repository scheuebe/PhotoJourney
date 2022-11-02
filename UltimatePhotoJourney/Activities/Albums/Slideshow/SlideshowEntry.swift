//
//  SlideshowEntrxy.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 16.08.22.
//

import SwiftUI
import AVFoundation

struct SlideshowEntry: View {
    // load user settings
    @AppStorage("showExactLocation") var showExactLocation: Bool = true
    @AppStorage("changePictureAutomatically") var changePictureAutomatically: Bool = false
    @AppStorage("showClassificationLabels") var showClassificationLabels = true
    @AppStorage("playSoundsAutomatically") var playSoundsAutomatically = true
    @AppStorage("timeBetweenChanges") var timeBetweenChanges: Double = 3
    @AppStorage("showProgressBar") var showProgressBar: Bool = false
    @AppStorage("enableSurveyMode") var enableSurveyMode: Bool = false
    @AppStorage("showSidebar") var showSidebar: Bool = true
    @AppStorage("leftHandModeSidebar") var leftHandModeSidebar: Bool = false
    @AppStorage("downloadSounds") var downloadSounds: Bool = false
    @AppStorage("debugMode") var debugMode: Bool = false
    
    // sound API
    @State var soundObjectController = SoundObjectController.shared
    @State var soundList = SoundList.empty
    @State var isPlaying: Bool = false
    @State var isSearching: Bool = true
    @State var playSoundIndex: Int = 0
    
    // part of the ML
    let model = Resnet50()
    @State private var predictsToShow: Int = 1
    @State private var soundResult = ""
    @State private var classificationLabel: String = ""
    
    // to play audio effects
    @State var audioPlayer : AVPlayer?
    
    // for real data
    var item: Item
    @Binding var index: Int
    
    // timer
    @Binding var isActive: Bool
    @Binding var timeRemaining: Double
    
    // sidebar
    @State var isContextMenuOpen: Bool = false
    let newGesture = TapGesture().onEnded {
        print("in menu")
    }
    @State var isPlayPressed: Bool = false
    @State var isShufflePressed: Bool = false
    @State var isMorePressed: Bool = false
    
    // return back to AlbumDetailView
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var downloadManager: DownloadManager
    
    var body: some View {
        VStack {
            if !enableSurveyMode {
                HStack {
                    ImageMetaData(item: item)
                        .foregroundColor(.white)
                    
                    Button {
                        self.audioPlayer?.pause()
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        CloseButton()
                            .padding([.top, .bottom, .trailing])
                    }
                }
                .padding(.top, 35)
                .background(BlurView(style: .systemThickMaterialDark).ignoresSafeArea())
                .overlay(
                    HStack {
                        if showProgressBar {
                            let perfectProgress = 1-min(max(timeRemaining/timeBetweenChanges,0),1)
                            
                            Capsule()
                                .fill(.black.opacity(0.01))
                                .overlay(
                                    withAnimation {
                                        Capsule()
                                            .fill(Color.appColor)
                                        //.opacity(showProgressBar ? 1 : 0)
                                            .frame(width: .screenWidth * 1.05 * perfectProgress)
                                    } ,alignment: .leading
                                )
                        }
                    }
                        .frame(width: .screenWidth, height: 5),
                    alignment: .bottom
                )
            }
            
            Spacer()
            // MARK: DEBUG
            if debugMode {
                Text("Index: \(index)")
                Text("Item classification \(String(describing: item.classificationResult))")
            }
            
            if showClassificationLabels {
                withAnimation {
                    Text("\(classificationLabel)")
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                        //.foregroundColor(.white)
                }
                .padding(.bottom, 50)
            }

        }

        .background {
            ZoomableScrollView {
                Image(uiImage: UIImage(data: item.mediaData!) ?? UIImage())
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
                    .overlay {
                        if !isContextMenuOpen {
                            HStack {
                                Rectangle()
                                    .fill(.black.opacity(0.001))
                                    .onTapGesture(count: 1) {
                                        backward()
                                    }
                                Rectangle()
                                    .fill(.black.opacity(0.001))
                                    .onTapGesture {
                                        forward()
                                    }
                            }
                        }
                    }
                    .onTapGesture {
                        isContextMenuOpen = false
                        isActive = true
                    }
                    .onLongPressGesture(minimumDuration: 30) {
                        isActive = true
                    } onPressingChanged: { inProgress in
                        if inProgress {
                            isActive = false
                        } else {
                            isActive = true
                        }
                    }
            }
            
            .frame(width: .screenWidth, height: enableSurveyMode ? .screenHeight : .screenHeight*0.88, alignment: .center)
            .cornerRadius(enableSurveyMode ? 0 : 22)
            .clipped()
            .overlay(
                sidebar
                    .opacity(showSidebar ? 1 : 0)
                    .offset(y: enableSurveyMode ? -22 : 0)
                ,alignment: leftHandModeSidebar ? .bottomLeading : .bottomTrailing
            )
            /*.background(
                Rectangle()
                    .fill(.black.opacity(0.4))
                    .frame(width: .screenWidth, height: .screenHeight)
                    .opacity(isContextMenuOpen ? 1 : 0)
                    .onTapGesture {
                        print("here")
                        isContextMenuOpen = false
                    }
                    ,alignment: .center
            )*/
        }
        .task {
            self.classificationLabel = await classifyImageWithAsync()
            if !downloadSounds {
                await callSoundAPI(classificationResult: classificationLabel)
                print(item.itemSoundResult)
                getSoundFromAPI(url: soundList.results[item.itemSoundResult].previews.preview_lq_mp3)
                print("\(soundList.results[item.itemSoundResult].previews.preview_lq_mp3)")
                isSearching = false
            }
        }
        .onDisappear {
            self.audioPlayer?.pause()
        }
        .onAppear {
            if downloadSounds {
                isSearching = false
                downloadManager.checkFileExists(fileName: item.classificationResult ?? "")
                print("File with fileName: \(String(describing: item.classificationResult)) exists")
                
                playLocalFile()
            }
        }
    }
    
    var sidebar: some View {
        VStack(alignment: .center) {
            // if isSearching {
                /*ProgressView()
                    .scaleEffect(1.25)
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    .padding()*/
            // } else {
                Button {
                    controlAudioPlayer()
                } label: {
                    Image(systemName: self.isPlaying ? "pause.fill" : "play.fill")
                        .frame(width: 20, height: 20)
                        .font(.title)
                        .foregroundColor(.white)
                        .scaleEffect(isPlayPressed ? 1.3 : 1.0)
                        .padding()
                }
                .pressEvents {
                    withAnimation(.easeInOut.delay(1.0)) {
                        isPlayPressed = true
                    }
                } onRelease: {
                    withAnimation(.easeInOut.delay(1.0)) {
                        isPlayPressed = false
                    }
                }
                
                Button {
                    getNextSoundFromAPI()
                } label: {
                    Image(systemName: "shuffle")
                        .font(.title2)
                        .foregroundColor(.white)
                        .scaleEffect(isShufflePressed ? 1.3 : 1.0)
                        .padding(.vertical, 10)
                        .padding(.bottom, 2)
                }
                .pressEvents {
                    withAnimation(.easeInOut.delay(1.0)) {
                        isShufflePressed = true
                    }
                } onRelease: {
                    withAnimation(.easeInOut.delay(1.0)) {
                        isShufflePressed = false
                    }
                }
                
                Button {
                    isContextMenuOpen = true
                    isActive.toggle()
                } label : {
                    // hint: sort order is reversed
                    Menu {
                        Button {
                            showSidebar.toggle()
                            isContextMenuOpen = false
                            isActive = true
                        } label: {
                            HStack {
                                Image(systemName: leftHandModeSidebar ? "chevron.left" : "chevron.right")
                                Text("Hide menu")
                            }
                        }
                        
                        Button {
                            showClassificationLabels.toggle()
                            isContextMenuOpen = false
                            isActive = true
                        } label: {
                            HStack {
                                Image(systemName: showClassificationLabels ? "text.badge.xmark" : "text.magnifyingglass")
                                Text(showClassificationLabels ? "Disable classification results" : "Show classification results")
                            }
                        }
                        
                        Button {
                            playSoundsAutomatically.toggle()
                            isContextMenuOpen = false
                            isActive = true
                        } label: {
                            HStack {
                                Image(systemName: playSoundsAutomatically ? "speaker.zzz.fill" : "speaker.wave.3.fill")
                                Text(playSoundsAutomatically ? "Mute sound" : "Play sound")
                            }
                        }
                        
                        Button {
                            timeRemaining = timeBetweenChanges
                            changePictureAutomatically.toggle()
                            isContextMenuOpen = false
                            isActive = true
                        } label: {
                            HStack {
                                Image(systemName: changePictureAutomatically ? "stop.fill" :"play.fill")
                                Text(changePictureAutomatically ? "Stop slideshow" : "Start slideshow")
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.bottom, 3)
                            .padding()
                            
                    }
               // }
            }
        }
        .shadow(color: .black, radius: 10)
        .background(BlurView(style: .systemUltraThinMaterialDark))
        .backgroundStyle(cornerRadius: 14, opacity: 0.4)
        .padding([.leading, .trailing, .bottom], 16)
    }
    
    private func classifyImageWithAsync() async -> String {
        guard let image = UIImage(data: item.mediaData!),
              let centercroppedImage = image.cropImageToSquare(image: image),
              // MARK: SquezeNet does need 227x227 pixels
              // let resizedImage = image.resizeImageTo(size:CGSize(width: 227, height: 227)),
              
              // MARK: Resnet50 or MobileNetV2 need 224x224 pixels
              let resizedImage = centercroppedImage.resizeImageTo(size:CGSize(width: 224, height: 224)),
              let buffer = resizedImage.convertToBuffer() else {
              return ""
        }
        
        let output = try? model.prediction(image: buffer)
        
        if let output = output {
            let results = output.classLabelProbs.sorted { $0.1 > $1.1 }
            let result = results.prefix(predictsToShow).map { (key, value) in
                let formattedResultOfClassification = formatClassificationResultToStringForAPI(input: key)
                self.soundResult = formattedResultOfClassification[0]
                return "\(key) = \(String(format: "%.2f", value * 100))%"
            }.joined(separator: "\n")

            return result
        }
        return ""
    }
    
    func formatClassificationResultToStringForAPI(input: String) -> [String] {
        var cutResults = input.components(separatedBy: CharacterSet(charactersIn: ","))
        
        for i in cutResults.indices {
            let str = cutResults[i].trimmingCharacters(in: .whitespacesAndNewlines)
            cutResults[i] = str
        }
        
        return cutResults
    }
    
    func callSoundAPI(classificationResult: String) async {
        soundObjectController.queryString = soundResult.replacingOccurrences(of: " ", with: "%20")
        let apiSoundList = await soundObjectController.search()
        soundList = apiSoundList
        // print(soundList.results[0])
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: audioPlayer?.currentItem, queue: nil) { object in
            playerDidFinishPlaying(notification: Notification(name: Notification.Name.AVPlayerItemDidPlayToEndTime))
        }
        isSearching = false
    }

    func playerDidFinishPlaying(notification: Notification) {
        isPlaying = false
        self.audioPlayer?.seek(to: CMTime(seconds: 0.0, preferredTimescale: 1))
        NotificationCenter.default.removeObserver(self)
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
        
         if playSoundsAutomatically {
            isPlaying = true
            audioPlayer?.play()
        } else {
            isPlaying = false
        }
    }
    
    func getNextSoundFromAPI() {
        audioPlayer?.pause()
        
        if playSoundIndex < 10 && playSoundIndex <= soundList.count {
            playSoundIndex = playSoundIndex + 1
            print("PlaySoundIndex: \(playSoundIndex)")
        }
        if playSoundIndex == 9 && playSoundIndex <= soundList.count {
            playSoundIndex = 0
        }
        
        // save changed sound to CoreDate to improve the next slideshow experience
        item.soundResult = Int16(playSoundIndex)
        dataController.save()
        
        getSoundFromAPI(url: soundList.results[item.itemSoundResult].previews.preview_lq_mp3)
        isPlaying = true
        audioPlayer?.play()
    }
    
    func controlAudioPlayer() {
        if audioPlayer?.rate != 0 && audioPlayer?.error == nil {
            self.isPlaying = false
            self.audioPlayer?.pause()
        } else {
            self.isPlaying = true
            self.audioPlayer?.play()
        }
    }
    
    func playLocalFile() {
        let playerItem = downloadManager.getFileAsset(fileName: item.classificationResult!)
        print("Classification Result: \(String(describing: item.classificationResult))")
        print("Play file: \(String(describing: playerItem))")
        if let playerItem = playerItem {
            audioPlayer = AVPlayer(playerItem: playerItem)
        }
        isPlaying = true
        audioPlayer?.play()
    }
    
    func stopAudio() {
        self.audioPlayer?.pause()
    }
    
    func forward() {
        if index < item.album!.itemsCount {
            withAnimation {
                index += 1
            }
        } else {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func backward() {
        if index > 0 {
            withAnimation {
                index -= 1
            }
       } else {
            presentationMode.wrappedValue.dismiss()
       }
    }
}
