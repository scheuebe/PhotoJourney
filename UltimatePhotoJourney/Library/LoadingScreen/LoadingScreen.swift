//
//  LoadingScreen.swift
//  PHPickerDemo
//
//  Created by Bernhard Scheuermann on 10.12.21.
//

import SwiftUI

struct LoadingScreen: View {
    @Binding var showLoadingScreen: Bool
    @Binding var actualStatus: Int
    @Binding var numberOfImport: Int
    @State var loadingTitle: String?

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var navigationModel: NavigationModel

    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .edgesIgnoringSafeArea(.all)

            VStack {
                ActivityIndicatorView(isVisible: $showLoadingScreen, type: .rotatingDots)
                    .frame(width: 60, height: 60)

                if loadingTitle != "" {
                    Text(loadingTitle!)
                        .padding(5)
                        .font(.title3)
                }

                Text("\(actualStatus)/\(numberOfImport)")
            }
            .foregroundColor(.orange)
            .offset(y: -50)
        }
        // test for the overlay over the loadingScreen
        /*
        .onAppear {
            navigationModel.showTab = false
            navigationModel.showNav = false
        }
         */
        .opacity(actualStatus < numberOfImport ? 1 : 0)
    }

    // theoretical closing method
    /*
     func closeLoading() {
        presentationMode.wrappedValue.dismiss()
        showLoadingScreen = false
    }
     */
}

/*
struct LoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreen()
    }
}
*/
