//
//  ResizedSlideshowExamples.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 10.10.22.
//

import SwiftUI
import UIKit

struct ResizedSlideshowExamples: View {
    var item: Item
    @Binding var index: Int
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(uiImage: UIImage(data: item.mediaData!) ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Spacer(minLength: 50)
            
            Image(uiImage: UIImage(data: item.mediaData!)!)
                .resizable()
                .scaledToFill()
                .frame(width: 224, height: 224)
                .clipped()
            
            // Image(uiImage: UIImage(data: item.mediaData!)?.resizeImageTo(size: CGSize(width: 224, height: 224)) ?? UIImage())
            
            Spacer()
        }
        .padding()
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

/*
 struct ResizedSlideshowExamples_Previews: PreviewProvider {
 static var previews: some View {
 ResizedSlideshowExamples()
 }
 }
 */
