//
//  SettingsSlideshow.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 16.08.22.
//

import SwiftUI

struct SettingsSlideshow: View {
    @AppStorage("changePictureAutomatically") var changePictureAutomatically: Bool = false
    @AppStorage("timeBetweenChanges") var timeBetweenChanges: Double = 3
    @AppStorage("showClassificationLabels") var showClassificationLabels: Bool = true
    @AppStorage("playSoundsAutomatically") var playSoundsAutomatically: Bool = true
    @AppStorage("showProgressBar") var showProgressBar: Bool = false
    @AppStorage("showSidebar") var showSidebar: Bool = true
    @AppStorage("leftHandModeSidebar") var leftHandModeSidebar: Bool = false
    @AppStorage("endSlideshowAfterLastEntry") var endSlideshowAfterLastEntry: Bool = false
    var title: String = ""
    
    var body: some View {
        List {
            Section(header: Text("Slideshow Automation")) {
                Toggle("Change picture automatically", isOn: $changePictureAutomatically)
                
                if changePictureAutomatically {
                    Toggle("End after last Entry", isOn: $endSlideshowAfterLastEntry)
                        .disabled(changePictureAutomatically == false)
                    
                    Toggle("Show progress bar", isOn: $showProgressBar)
                        .disabled(changePictureAutomatically == false)
                    
                    HStack {
                        Text("Time between the changes:")
                            .disabled(changePictureAutomatically == false)
                        Spacer()
                        Text("\(timeBetweenChanges, specifier: "%.2f") sec")
                    }
                    
                    HStack(alignment: .center) {
                        Button {
                            timeBetweenChanges -= 0.25
                        } label: {
                            Image(systemName: "minus")
                        }
                        
                        Slider(value: $timeBetweenChanges, in: 1...8, step: 0.25)
                        
                        Button {
                            timeBetweenChanges += 0.25
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    .accentColor(changePictureAutomatically ? .appColor : .appColor.opacity(0.3))
                    .disabled(changePictureAutomatically == false)
                    .buttonStyle(BorderlessButtonStyle())
                    .listRowSeparator(.hidden)
                }
                
                // additional feature?
                // wait for finish of sounds?
            }
            
            Section(header: Text("Imaged-Based Sounds")) {
                Toggle("Show classification labels", isOn: $showClassificationLabels)
                Toggle("Play sounds automatically", isOn: $playSoundsAutomatically)
                
                // additional feature
                // Text("Save shuffled sounds to improve slideshow experience")
            }
            
            Section(header: Text("Sidebar"), footer: Text("Small menu inside the slideshow to have quick access to selected options")) {
                Toggle("Show Sidebar", isOn: $showSidebar)
                Toggle("Left hand mode", isOn: $leftHandModeSidebar)
            }
        }
        .toggleStyle(SwitchToggleStyle(tint: .appColor))
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsSlideshow_Previews: PreviewProvider {
    static var previews: some View {
        SettingsSlideshow()
    }
}
