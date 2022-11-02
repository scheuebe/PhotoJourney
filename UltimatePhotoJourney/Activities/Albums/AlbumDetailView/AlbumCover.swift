//
//  AlbumCover.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 18.02.22.
//

import SwiftUI

struct AlbumCover: View {
    @ObservedObject var album: Album

    var body: some View {
        GeometryReader { geo in
            VStack {
                if album.coverImage != nil {
                    Image(uiImage: UIImage(data: album.coverImage!) ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                     Image(systemName: "photo")
                        .resizable()

                        .aspectRatio(contentMode: .fit)
                        .padding(40)
                        .offset(y: -44)
                }
            }
            .edgesIgnoringSafeArea(.top)
            .frame(width: geo.size.width, height: geo.size.width)
        }
    }
}

struct AlbumCover_Previews: PreviewProvider {
    static var previews: some View {
        AlbumCover(album: Album.example)
    }
}
