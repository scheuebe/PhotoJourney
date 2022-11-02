//
//  StoryCard.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 19.08.22.
//

import SwiftUI

struct StoryCard: View {
    @State var index: Int
    @EnvironmentObject var dataController: DataController
    // return back to AlbumDetailView
    @Environment(\.presentationMode) var presentationMode
    
    // Bug: status bar is still black
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("tomorrowland-\(index)")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height*0.9, alignment: .center)
                    .cornerRadius(14)
                    .clipped()
                
                DetectableTapGesturePositionView { location in
                    getScreenPosition(point: location)
                }
                .overlay(
                    HStack {
                        Button {
                            // settings
                        } label: {
                            Image(systemName: "ellipsis")
                                .imageScale(.large)
                                .padding(8)
                        }
                        
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title)
                        }
                    }
                    .foregroundColor(.white)
                    .padding(),
                    alignment: .topTrailing
                )
                .frame(width: geo.size.width, height: geo.size.height*0.9, alignment: .center)
            }
            .rotation3DEffect(
                getAngle(geo: geo),
                axis: (x: 0, y: 1, z: 0),
                anchor: geo.frame(in: .global).minX > 0 ? .leading : .trailing,
                perspective: 2.5
            )
        }
    }
    
    func getAngle(geo: GeometryProxy) -> Angle {
        
        // converting Offset into 45 Deg rotation...
        let progress = geo.frame(in: .global).minX / geo.size.width
        
        let rotationAngle: CGFloat = 45
        let degrees = rotationAngle * progress
        
        return Angle(degrees: Double(degrees))
    }
    
    // still static
    func getScreenPosition(point: CGPoint) {
        if point.x  <= .screenWidth / 2 {
            if index > 1 {
                index -= 1
            } else {
                presentationMode.wrappedValue.dismiss()
            }
        } else {
            if index < 9 {
                index += 1
            } else {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct StoryCard_Previews: PreviewProvider {
    static var previews: some View {
        StoryCard(index: 1)
    }
}
