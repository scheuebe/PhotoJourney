//
//  SettingsPlaceholder.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 13.05.22.
//

import SwiftUI

struct SettingsPlaceholder: View {
    var title: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(title)
                .font(.title3)
                .padding()
            
            Text("More is coming soon :)")
            
            Spacer()
            Spacer()
        }
    }
}

struct SettingsPlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPlaceholder()
    }
}
