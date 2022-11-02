//
//  PlayButton.swift
//  PhotoJourney
//
//  Created by Bernhard Scheuermann on 23.12.21.
//

import SwiftUI

struct Play2Button: View {
    var body: some View {
        Image(systemName: "play.circle")
            .font(.system(size: 17, weight: .bold))
            .frame(width: 36, height: 36)
            .foregroundColor(.appColor)
            .background(.ultraThinMaterial)
            .backgroundStyle(cornerRadius: 14, opacity: 0.4)

        /*ZStack(alignment: .center) {
            Circle()
                .fill(Color("AppColor"))
                .frame(width: 200, height: 200)
            Image(systemName: "play.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.white)
                .padding(.leading)
        }*/
        // .scaleEffect(1/4)
        // .frame(width: 200/4, height: 200/4)
    }
}

struct Play2Button_Previews: PreviewProvider {
    static var previews: some View {
        Play2Button()
    }
}
