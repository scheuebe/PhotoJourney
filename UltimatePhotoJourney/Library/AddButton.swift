//
//  AddButton.swift
//  PhotoJourney
//
//  Created by Bernhard Scheuermann on 04.11.21.
//

import SwiftUI

struct AddButton: View {
    var body: some View {
        Image(systemName: "plus.circle")
            .font(.system(size: 17, weight: .bold))
            .frame(width: 36, height: 36)
            .foregroundColor(.appColor)
            .background(.ultraThinMaterial)
            .backgroundStyle(cornerRadius: 14, opacity: 0.4)
    }
}

struct AddButton_Previews: PreviewProvider {
    static var previews: some View {
        AddButton()
    }
}
