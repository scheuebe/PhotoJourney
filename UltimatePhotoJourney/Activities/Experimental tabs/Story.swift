//
//  Story.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 19.08.22.
//

import SwiftUI

struct Story: View {
    // configuration of own tab
    static let tag: String? = "Story"
    
    var album: Album
    
    @State private var indexOfCurrentItem = 1
    
    // to toggle global tab- and navBar
    @EnvironmentObject var navigationModel: NavigationModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        TabView(selection: $indexOfCurrentItem) {
            ForEach(1...9, id: \.self) { index in
                StoryCard(index: index)
            }
        }
        .swipeToDismiss()
        .background(.black)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .navigationBarHidden(true)
        .onAppear(perform: toggleCustomNavigation)
        .onDisappear(perform: toggleCustomNavigation)
    }
    
    func showPreviousStory() {
        if indexOfCurrentItem <= 1 {
            indexOfCurrentItem += 1
        } else {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func toggleCustomNavigation() {
        withAnimation {
            navigationModel.showNav.toggle()
            navigationModel.showTab.toggle()
        }
    }
}

struct Story_Previews: PreviewProvider {
    static var previews: some View {
        Story(album: Album.example)
    }
}
