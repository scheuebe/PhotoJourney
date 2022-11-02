//
//  ToggleButton.swift
//  PhotoJourney
//
//  Created by Bernhard Scheuermann on 07.11.21.
//

import SwiftUI

struct ToggleButton: View {
    var body: some View {
        Image(systemName: "switch.2")
            .font(.system(size: 15, weight: .bold))
            .frame(width: 36, height: 36)
            .foregroundColor(.appColor)
            .background(.ultraThinMaterial)
            .backgroundStyle(cornerRadius: 14, opacity: 0.4)
    }
}

struct ToggleButton_Previews: PreviewProvider {
    static var previews: some View {
        ToggleButton()
    }
}
