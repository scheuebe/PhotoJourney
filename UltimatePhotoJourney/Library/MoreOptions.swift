//
//  MoreOptions.swift
//  PhotoJourney
//
//  Created by Bernhard Scheuermann on 12.11.21.
//

import SwiftUI

struct MoreOptions: View {
    var body: some View {
        Image(systemName: "ellipsis.circle")
            .font(.system(size: 17, weight: .bold))
            .frame(width: 36, height: 36)
            .foregroundColor(.appColor)
            .background(.ultraThinMaterial)
            .backgroundStyle(cornerRadius: 14, opacity: 0.4)
    }
}

struct MoreOptions_Previews: PreviewProvider {
    static var previews: some View {
        MoreOptions()
    }
}
