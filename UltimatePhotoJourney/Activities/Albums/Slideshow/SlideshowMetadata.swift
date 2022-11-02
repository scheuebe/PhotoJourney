//
//  SlideshowMetaData.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 26.08.22.
//

import SwiftUI
import AVFoundation

struct SlideshowMetadata: View {
// load user settings
@AppStorage("showClassificationLabels") var showClassificationLabels = true
@AppStorage("playSoundsAutomatically") var playSoundsAutomatically = true

// sound API
@State var soundObjectController = SoundObjectController.shared
@State var soundList = SoundList.empty
@State var isPlaying: Bool = false
@State var isSearching: Bool = true
@State var playSoundIndex: Int = 0

// part of the ML
let model = MobileNetV2()
@State private var predictsToShow: Int = 1
@State private var soundResult = ""
@State private var classificationLabel: String = ""

// to play audio effects
@State var audioPlayer: AVPlayer?

// for real data
var item: Item
@State var index: Int

// for pinch to zoom
@State var scaleImage: CGFloat = 1.0
@State private var imageOffset:CGSize = .zero

// return back to AlbumDetailView
@Environment(\.presentationMode) var presentationMode

var body: some View {
    VStack {
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
        .background(BlurView(style: .systemUltraThinMaterialDark).ignoresSafeArea())
        
        Spacer()
        
        VStack(spacing: 10) {
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
            
            if showClassificationLabels {
                Text(classificationLabel)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(width: .screenWidth*0.85)
        .padding()
        .foregroundColor(.white)
        .background(BlurView(style: .systemUltraThinMaterialDark))
        .backgroundStyle(cornerRadius: 14, opacity: 0.4)
        .padding(.bottom, 50)
    }

    .background {
        //ScrollView([.horizontal, .vertical]) {
            Image(uiImage: UIImage(data: item.mediaData!) ?? UIImage())
                .resizable()
                .scaledToFill()
                .scaleEffect(scaleImage)
                .frame(width: .screenWidth, height: .screenHeight*0.9, alignment: .center)
                
                .cornerRadius(14)
                .clipped()
                
                .gesture(MagnificationGesture()
                    .onChanged { value in
                        withAnimation {
                            self.scaleImage = value.magnitude
                        }
                    }
                    .onEnded { _ in
                        withAnimation {
                            resetImageState()
                        }
                    }
                )
                .onTapGesture(count: 2) {
                    if scaleImage == 1 {
                        withAnimation {
                            self.scaleImage = 2
                        }
                    } else {
                        withAnimation {
                            resetImageState()
                        }
                    }
                }
                
                /*.onTapGesture(count: 1) {
                    DetectableTapGesturePositionView { location in
                        tapLeftOrRight(point: location)
                    }
                }*/
                
                /*.gesture (
                    DragGesture(minimumDistance: 0).onEnded({ (value) in
                        tapLeftOrRight(point: value.location)
                    })
                )*/
        //}
    }
    .task {
        self.classificationLabel = await classifyImageWithAsync()
        await callSoundAPI(classificationResult: classificationLabel)
        playSounds(url: soundList.results[playSoundIndex].previews.preview_lq_mp3)
        isSearching = false
    }
    .onDisappear {
        self.audioPlayer?.pause()
    }
}

private func classifyImageWithAsync() async -> String {
    guard let image = UIImage(data: item.mediaData!),
          let resizedImage = image.resizeImageTo(size:CGSize(width: 224, height: 224)),
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

func playSounds(url: String) {
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

func stopAudio() {
    self.audioPlayer?.pause()
}

private func resetImageState() {
    scaleImage = 1
}

// still static
func tapLeftOrRight(point: CGPoint) {
    if point.x  <= .screenWidth / 2 {
        if index > 0 {
            withAnimation {
                index -= 1
            }
       } else {
            presentationMode.wrappedValue.dismiss()
       }
    } else {
        if index < item.album!.itemsCount-1 {
            withAnimation {
                index += 1
            }
        } else {
            presentationMode.wrappedValue.dismiss()
        }
    }
    print("\(index) zu \(item.album!.itemsCount)")
    print("\(point.x) in \(.screenWidth/2)")
}
}

struct SlideshowMetadata_Previews: PreviewProvider {
static var previews: some View {
    SlideshowMetadata(item: Item.example, index: 0)
}
}
