//
//  AlbumHeaderView.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 11.01.22.
//

import SwiftUI

struct AlbumHeaderView: View {
    @ObservedObject var album: Album
    @State private var editAlbum = false

    var body: some View {
        HStack {
            Button {
                editAlbum.toggle()
            } label: {
                VStack(alignment: .leading) {
                    HStack {
                        Text(album.albumTitle)
                            .foregroundColor(.secondary)

                        Spacer()

                        Text("\(album.albumItems.count)")
                            .foregroundColor(.secondary)
                    }

                    ProgressView(value: album.completionAmount)
                        .accentColor(Color(album.albumColor))
                }

                Spacer()

                Image(systemName: "square.and.pencil")
                    .imageScale(.large)
            }
        }
        .sheet(isPresented: $editAlbum) {
            EditAlbumView(album: album)
        }
        .padding(.bottom, 10)
        .accessibilityElement(children: .combine)
    }
}

struct AlbumHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumHeaderView(album: Album.example)
    }
}
