//
//  PlayButton.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 13.01.2022.
//

import SwiftUI

struct PlayButton: View {
    var body: some View {
        VStack {
            PlayShape()
                .fill(Color.appColor.opacity(0.7))
                .overlay(
                    PlayShape()
                        .stroke(.white, lineWidth: 2)
                )
                .frame(width: 52, height: 52)
                .background(
                    PlayShape()
                        .fill(
                            .angularGradient(
                                colors: [.blue, .red, .blue],
                                center: .center,
                                startAngle: .degrees(0),
                                endAngle: .degrees(360)
                            )
                        )
                        .blur(radius: 12)
                )
                .offset(x: 6)
        }
        .frame(width: 120, height: 120)
        .background(.ultraThinMaterial)
        .cornerRadius(60)
        .modifier(OutlineOverlay(cornerRadius: 60))
        .overlay(CircularView(value: 1, lineWidth: 8))
        .shadow(color: Color("Shadow").opacity(0.2), radius: 30, x: 0, y: 30)
        /*
        .overlay(
            Text("12:08")
                .font(.footnote.weight(.semibold))
                .padding(2)
                .padding(.horizontal, 2)
                .background(Color(.systemBackground).opacity(0.3))
                .cornerRadius(4)
                .offset(y: 44)
        )
         */
    }
}

struct PlayButton_Previews: PreviewProvider {
    static var previews: some View {
        PlayButton()
    }
}
