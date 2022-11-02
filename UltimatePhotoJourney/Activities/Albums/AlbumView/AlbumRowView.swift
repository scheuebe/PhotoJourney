//
//  AlbumRowView.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 20.02.22.
//

import SwiftUI

struct AlbumRowView: View {
    @ObservedObject var album: Album

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottomLeading) {
                AlbumCover(album: album)
                    .frame(width: geo.size.width, height: geo.size.width*0.7)
                    .clipped()
                    .overlay(LinearGradient(gradient: Gradient(
                        colors: [Color.black.opacity(0.8),
                                 Color.black.opacity(0)]),
                                            startPoint: .bottom,
                                            endPoint: .center)
                    )
                VStack(alignment: .leading) {
                    HStack {
                        Text(album.albumTitle)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Spacer()

                        HStack {
                            Image(systemName: "photo.on.rectangle.angled")
                            Text("\(album.itemsCount)")
                        }
                        .padding(.horizontal)
                        .foregroundColor(.white.opacity(0.6))
                    }
                    // --- Text is still not automatically fetched by the location of the images
                    // --- location is linking to a map?
                    if album.albumDetail != "" {
                        HStack {
                            Image(systemName: "location")

                            Text(album.albumDetail)
                                .font(.title3)
                                .fontWeight(.thin)

                        }
                        .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding(.leading, 20)
                .padding(.bottom, 20)

            }
            .cornerRadius(20.0)
            .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
        }
    }
}

struct AlbumRowView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumRowView(album: Album.example)
    }
}
