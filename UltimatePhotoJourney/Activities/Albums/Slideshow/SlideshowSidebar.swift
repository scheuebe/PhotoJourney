//
//  SlideshowSidebar.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 11.09.22.
//

// MARK: WIP refactoring
/*
import SwiftUI
import AVFoundation

struct SlideshowSidebar: View {
    // load user settings
    @AppStorage("changePictureAutomatically") var changePictureAutomatically: Bool = false
    @AppStorage("showClassificationLabels") var showClassificationLabels = true
    @AppStorage("playSoundsAutomatically") var playSoundsAutomatically = true
    @AppStorage("timeBetweenChanges") var timeBetweenChanges: Double = 3
    @AppStorage("showProgressBar") var showProgressBar: Bool = false
    @AppStorage("showSidebar") var showSidebar: Bool = true
    @AppStorage("leftHandModeSidebar") var leftHandModeSidebar: Bool = false
    
    // timer
    @Binding var isActive: Bool
    @Binding var timeRemaining: Double
    
    // sound API
    @State var soundObjectController = SoundObjectController.shared
    
    // sidebar
    @State var isContextMenuOpen: Bool = false
    let newGesture = TapGesture().onEnded {
        print("in menu")
    }
    @State var isPlayPressed: Bool = false
    @State var isShufflePressed: Bool = false
    @State var isMorePressed: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            if soundObjectController.isSearching {
                ProgressView()
                    .scaleEffect(1.25)
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    .padding()
            } else {
                Button {
                    soundObjectController.controlAudioPlayer()
                } label: {
                    Image(systemName: self.soundObjectController.isPlaying ? "pause.fill" : "play.fill")
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
                    soundObjectController.getNextSoundFromAPI(soundList: soundObjectController.soundList)
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
                }
            }
        }
        .shadow(color: .black, radius: 10)
        .background(BlurView(style: .systemUltraThinMaterialDark))
        .backgroundStyle(cornerRadius: 14, opacity: 0.4)
        .padding([.leading, .trailing, .bottom], 16)
    }
}

/*
struct SlideshowSidebar_Previews: PreviewProvider {
    static var previews: some View {
        SlideshowSidebar()
    }
}
 */
*/
