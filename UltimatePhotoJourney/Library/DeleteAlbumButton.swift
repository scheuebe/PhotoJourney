//
//  DeleteAlbumButton.swift
//  PhotoJourney
//
//  Created by Bernhard Scheuermann on 15.11.21.
//

import SwiftUI

struct DeleteAlbumButton: View {
    @Environment(\.editMode) var editMode
    @EnvironmentObject var dataController: DataController

    let index: Int
    let album: Album
    @State var showDeleteConfirmationAlert = false
    let onDelete: (IndexSet) -> Void

    var body: some View {
        VStack {
            if self.editMode?.wrappedValue == .active {
                Button {
                    showDeleteConfirmationAlert.toggle()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color.white)
                        .padding(6)
                        .background(Color.red)
                        .background(.ultraThinMaterial, in: Circle())
                    .backgroundStyle(cornerRadius: 18)
                }
            } else {
                EmptyView()
            }
        }
        .alert("Are you sure?", isPresented: $showDeleteConfirmationAlert) {
            Button("Delete it", role: .destructive) {
                deleteAlbum()
            }
        }
    }

    func deleteAlbum() {
        withAnimation {
            dataController.delete(album)
            dataController.save()
        }
    }
}

/*
struct DeleteAlbumButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAlbumButton()
    }
}
 */
