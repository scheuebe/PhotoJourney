//
//  Slideshow.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 08.08.22.
//

import SwiftUI
import AVFoundation

struct Slideshow: View {
    // load user settings
    @AppStorage("changePictureAutomatically") var changePictureAutomatically: Bool = false
    @AppStorage("timeBetweenChanges") var timeBetweenChanges: Double = 3
    @AppStorage("showProgressBar") var showProgressBar: Bool = false
    @AppStorage("endSlideshowAfterLastEntry") var endSlideshowAfterLastEntry: Bool = false
    
    // for real data
    var album: Album
    @State var indexCurrentItem: Int = 0

    // to control automatic slideshow
    @State private var timeRemaining: Double = 3.5
    @State private var isActive: Bool = false
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    // long press gesture
    @GestureState var press: Bool = false
    
    // Progress
    @State var timerProgress: CGFloat = 0
    
    // to toggle global tab- and navBar
    @EnvironmentObject var navigationModel: NavigationModel
    
    // return back to AlbumDetailView
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        TabView(selection: $indexCurrentItem) {
            ForEach(album.albumItemsCreationDateAscending.indices, id:\.self) { index in
                // MARK: to generate sample pictures of the thesis
                // ResizedSlideshowExamples(item: album.albumItemsCreationDateAscending[index], index: $indexCurrentItem )
                SlideshowEntry(item: album.albumItemsCreationDateAscending[index], index: $indexCurrentItem, isActive: $isActive, timeRemaining: $timeRemaining)
                    .edgesIgnoringSafeArea(.vertical)
                    .onAppear(perform: resetTimer)
            }
            .onReceive(timer) { _ in
                if changePictureAutomatically {
                    guard self.isActive else { return }
                    if self.timeRemaining > 0 {
                        self.timeRemaining -= 0.1
                    } else {
                        timeRemaining = timeBetweenChanges
                        getNextEntry()
                    }
                }
            }

        }
        .swipeToDismiss()
        .simultaneousGesture(
            DragGesture(minimumDistance: 10)
                .onChanged({ _ in
                    isActive = false
                })
                .onEnded({ _ in
                    isActive = true
                })
        )
        .edgesIgnoringSafeArea(.bottom)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .edgesIgnoringSafeArea(.top)
        .background(.black)
        .statusBar(hidden: true)
        .navigationBarHidden(true)
        .onAppear {
            toggleCustomNavigation()
            resetTimer()
        }
        .onDisappear(perform: toggleCustomNavigation)
    }
    
    func resetTimer() {
        timeRemaining = timeBetweenChanges
        isActive = true
    }
    
    func getNextEntry() {
        if indexCurrentItem < album.itemsCount-1 {
            withAnimation {
                indexCurrentItem += 1
            }
        } else {
            isActive = false
            
            if endSlideshowAfterLastEntry {
                // to enable automatic closure after the slideshow has ended
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    func getPreviousEntry() {
        if indexCurrentItem < album.itemsCount-1 && indexCurrentItem >= 0 {
            withAnimation {
                indexCurrentItem -= 1
            }
        }
    }
    
    func toggleCustomNavigation() {
        withAnimation {
            navigationModel.showNav.toggle()
            navigationModel.showTab.toggle()
        }
    }
}

struct Slideshow_Previews: PreviewProvider {
    static var previews: some View {
        Slideshow(album: Album.example)
    }
}
