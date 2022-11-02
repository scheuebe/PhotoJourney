//
//  AlbumSummaryView.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 13.01.22.
//

import SwiftUI

struct AlbumSummaryView: View {
    @ObservedObject var album: Album

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(album.albumItems.count) items")
                .font(.caption)
                .foregroundColor(.secondary)

            Text(album.albumTitle)
                .font(.title2)

            ProgressView(value: album.completionAmount)
                .accentColor(Color(album.albumColor))
        }
        .padding()
        .background(Color.secondarySystemGroupedBackground)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 5)
        // for VoiceOver to read the whole VStack together
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(album.label)
    }
}

struct AlbumSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumSummaryView(album: Album.example)
    }
}
