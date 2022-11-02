//
//  SettingsGeneral.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 18.08.22.
//

import SwiftUI

struct SettingsGeneral: View {
    @AppStorage("showExactLocation") var showExactLocation: Bool = true
    @AppStorage("showCountryNameInMetadata") var showCountryNameInMetadata: Bool = true
    @AppStorage("showAlbumNameInMetadata") var showAlbumNameInMetadata: Bool = false
    var title: String = ""
    
    var body: some View {
        List {
            Section(header: Text("Units")) {
                HStack {
                    Text("Length")
                    Spacer()
                    Text("Kilometers")
                }
                
                HStack {
                    Text("Temperature")
                    Spacer()
                    Text("Celsius")
                }
            }
            
            Section(header: Text("Metadata")) {
                Toggle("Show exact location", isOn: $showExactLocation)
                Toggle("Show country name next to flag", isOn: $showCountryNameInMetadata)
                Toggle("Show album name", isOn: $showAlbumNameInMetadata)
            }
        }
        .toggleStyle(SwitchToggleStyle(tint: .appColor))
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsGeneral_Previews: PreviewProvider {
    static var previews: some View {
        SettingsGeneral()
    }
}
