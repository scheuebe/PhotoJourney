//
//  NavigationBar.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 18.01.22.
//

import SwiftUI

struct NavigationBar: View {
    var title = ""
    @State var showSheet = false
    @Binding var album: Album
    @Binding var addNewAlbum: Bool
    @Binding var contentHasScrolled: Bool
    @StateObject var viewModel: AlbumView.ViewModel

    @EnvironmentObject var model: NavigationModel
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    // MARK: Future work
    // @AppStorage("showAccount") var showAccount = false
    // @AppStorage("isLogged") var isLogged = false

    var body: some View {
        ZStack {
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
                .frame(maxHeight: .infinity, alignment: .top)
                .blur(radius: contentHasScrolled ? 10 : 0)
                .opacity(contentHasScrolled ? 1 : 0)

            Text(title)
                .animatableFont(size: contentHasScrolled ? 22 : 34, weight: .bold)
                .foregroundStyle(colorScheme == .dark ? .black : .white)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .opacity(contentHasScrolled ? 0.7 : 1)

            HStack(spacing: 16) {
                Spacer()
                EditButton()
                    .animatableFont(size: 14, weight: .bold)
                    .frame(width: 40)
                    .padding(10)
                    .foregroundColor(.appColor)
                    .background(.ultraThinMaterial)
                    .backgroundStyle(cornerRadius: 14, opacity: 0.4)

                Button {
                    withAnimation {
                        album = viewModel.addAlbum()
                        addNewAlbum.toggle()
                    }
                } label: {
                    // In iOS 14.3 VoiceOver has a glitch that reads the label
                    // "Add Album" as "Add" no matter what accessibility label
                    // we give this toolbar button when using a label.
                    // As a result, when VoiceOver is running, we use a text view for
                    // the button instead, forcing a correct reading without losing
                    // the original layout.
                    if UIAccessibility.isVoiceOverRunning {
                        Text("Add Album")
                    } else {
                        AddButton()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding()
        }
        .offset(y: model.showNav ? 0 : -120)
        .accessibility(hidden: !model.showNav)
        // .offset(y: contentHasScrolled ? -16 : 0)
    }

    /*
    @ViewBuilder
    var avatar: some View {
        if isLogged {
            AsyncImage(url: URL(
                string: "https://picsum.photos/200"),
                transaction: .init(animation: .easeOut)
            ) { phase in
                switch phase {
                case .empty:
                    Color.white
                case .success(let image):
                    image.resizable()
                case .failure(_):
                    Color.gray
                @unknown default:
                    Color.gray
                }
            }
            .frame(width: 26, height: 26)
            .cornerRadius(10)
            .padding(8)
            .background(.ultraThinMaterial)
            .backgroundStyle(cornerRadius: 18, opacity: 0.4)
            .transition(.scale.combined(with: .slide))
        } else {
            // LogoView(image: "Avatar Default")
        }
    }
     */
}

/*
struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(contentHasScrolled: .constant(false))
            .environmentObject(Model())
    }
}
 */
