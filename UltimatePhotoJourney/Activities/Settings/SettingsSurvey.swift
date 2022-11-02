//
//  SettingsSurvey.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 15.09.22.
//

import SwiftUI

struct SettingsSurvey: View {
    @AppStorage("enableSurveyMode") var enableSurveyMode: Bool = false
    @AppStorage("downloadSounds") var downloadSounds: Bool = false
    @AppStorage("debugMode") var debugMode: Bool = false
    @AppStorage("tokenID") var tokenID: Int = 1
    @AppStorage("surveySize") var surveySize: Int = 1
    
    var title: String
    
    @Binding var alertMessage: String
    @Binding var showingAlert: Bool
    
    // to create the survey data
    var dataController: DataController
    @FetchRequest(sortDescriptors: []) var albums: FetchedResults<Album>
    @State var imageObjectController = ImageObjectController.shared
    
    @State var iconWidth: Double = 0
    let numbers = [Int](0...9)
    var maxSurveySize = 25
    
    @State var option = 1
    
    var body: some View {
        List {
            Section(header: Text("Survey Mode")) {
                Toggle(isOn: $enableSurveyMode, label: {
                    HStack {
                        SettingsRow(pictureName: "photo.artframe", text: "Survey Mode", iconWidth: $iconWidth)
                    }
                })
                
                Toggle(isOn: $downloadSounds, label: {
                    HStack {
                        SettingsRow(pictureName: "square.and.arrow.down.on.square", text: "Play Downloaded Sounds", iconWidth: $iconWidth)
                    }
                })
                
                Toggle(isOn: $debugMode, label: {
                    HStack {
                        SettingsRow(pictureName: "ladybug", text: "Debug Mode", iconWidth: $iconWidth)
                    }
                })
            }
            
            Section(header: Text("Survey with API pictures")) {
                VStack(alignment: .leading) {
                    SettingsRow(pictureName: "key.icloud", text: "TokenID", iconWidth: $iconWidth)
                    
                    Picker(selection: $tokenID, content: {
                        ForEach(0..<numbers.count, id:\.self) { index in
                            Text("Token\(self.numbers[index])")
                        }
                    }, label: {
                        SettingsRow(pictureName: "key.icloud", text: "TokenID", iconWidth: $iconWidth)
                    })
                    .pickerStyle(.wheel)
                }
                 
                VStack(alignment: .leading) {
                    SettingsRow(pictureName: "text.below.photo.fill", text: "Survey Size", iconWidth: $iconWidth)
                        .padding(.top, 8)
                    
                    Picker(selection: $surveySize, content: {
                        ForEach(1...maxSurveySize, id:\.self) { index in
                            Text("\(index)")
                        }
                    }, label: {
                        SettingsRow(pictureName: "photo", text: "Survey Size", iconWidth: $iconWidth)
                    })
                    .pickerStyle(.wheel)
                }
                
                Button {
                    Task {
                        await addRandomQuestionnaireData()
                        alertMessage = "Created Survey with API Images :)"
                        showingAlert = true
                    }
                } label: {
                    SettingsRow(pictureName: "list.bullet.rectangle.portrait", text: "Create API Survey Data", iconWidth: $iconWidth)
                }
            }
            
            Section(
                header: Text("Survey with JSON"),
                footer: Spacer().frame(height: 55)
            ) {
                Button {
                    addQuestionnaireData()
                    alertMessage = "Created JSON questionnaire data :)"
                    showingAlert = true
                } label: {
                    SettingsRow(pictureName: "opticaldiscdrive", text: "Create JSON Survey Data", iconWidth: $iconWidth)
                }
            }
        }
        .toggleStyle(SwitchToggleStyle(tint: .appColor))
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func addQuestionnaireData() {
        print("in JSON SettingsButton")
        try? dataController.createQuestionnaireData()
    }
    
    func addRandomQuestionnaireData() async {
        print("in SettingsButton")
        try? await dataController.createRandomQuestionnaire(imageObjectController: imageObjectController)
    }
}
