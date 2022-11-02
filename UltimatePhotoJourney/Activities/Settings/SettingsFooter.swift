//
//  SettingsFooter.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 27.08.22.
//

import SwiftUI

struct SettingsFooter: View {
    var body: some View {
        HStack {
            NavigationLink(destination: ChangelogView(title: "Changelog")) {
                Spacer()
                Image("photojourney_v2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, alignment: .center)
                    .grayscale(1)
                    .opacity(0.8)
                // .padding(.trailing, 4)
                //VStack(alignment: .leading) {
                Text("PhotoJourney version ") + Text("0.\(changeLog.last!.id)").underline()
                // Text("Stand: \(date, formatter: Self.dateFormat)")
                //}
                Spacer()
            }
        }
        .grayscale(1)
        .opacity(0.8)
        .padding(8)
    }
}

struct SettingsFooter_Previews: PreviewProvider {
    static var previews: some View {
        SettingsFooter()
    }
}
