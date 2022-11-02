//
//  SettingsRow.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 27.08.22.
//

import SwiftUI

struct SettingsRow: View {
    var pictureName: String
    var text: String
    
    @Binding var iconWidth: Double
    
    var body: some View {
        HStack {
            Image(systemName: "\(pictureName)")
                .sync(with: $iconWidth)
                .frame(width: iconWidth)
                .foregroundColor(.appColor)
            Text("\(text)")
                .foregroundColor(.primary)
        }
        .onPreferenceChange(SymbolWidthPreferenceKey.self) { iconWidth = $0 }
    }
}

/*
struct SettingsRow_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRow(pictureName: "play", text: "Test")
    }
}
 */
