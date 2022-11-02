//
//  SettingsAbout.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 27.08.22.
//

import SwiftUI

struct SettingsAbout: View {
    var title: String = ""
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    
                    Image("UniA-written")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                    
                    Spacer(minLength: .screenWidth*0.9/2)
                    
                    Image("ChairLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120)
                    
                    Spacer()
                }
                
                Group {
                    Spacer(minLength: 30)
                    
                    Text("Deep Learning Drives Mobile Application: Listen to Image-Based Audio")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer(minLength: 30)
                    
                    Text("Master Thesis")
                        .fontWeight(.semibold)
                    Text("in the study program Business Informatics M.Sc.")
                    
                    Spacer(minLength: 25)
                }
                
                Group {
                    Text("Faculty of Embedded Intelligence for Health Care and Wellbeing")
                    Text("Prof. Dr.-Ing. habil. Björn Schuller")
                    Text("at University of Augsburg")
                    
                    Spacer(minLength: 45)
                }
                
                Group {
                    Text("Presented by")
                    Text("Bernhard Scheuermann")
                    
                    Spacer(minLength: 45)
                }
                
                Group {
                    Text("Supervised by")
                    Text("Shuo Liu")
                    Text("Manuel Milling")
                    
                    Spacer(minLength: 35)
                }
                
                Text("November 2022")
            }
            .multilineTextAlignment(.center)
            .padding()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsAbout_Previews: PreviewProvider {
    static var previews: some View {
        SettingsAbout()
    }
}
