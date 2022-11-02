//
//  SettingsOverview.swift
//  PhotoJourney
//
//  Created by Bernhard Scheuermann on 23.02.22.
//
//  check SettingsViewModel for old 'Debug' files
//  refactoring needed

import SwiftUI

struct SettingsView: View {
    static let tag: String? = "Settings"
    @AppStorage("name") var name = ""
    
    @State private var iconWidth: Double = 0
    @State private var isDisabled: Bool = true
    
    // alert pop up
    @State private var showingAlert = false
    @State private var alertMessage = "Default message"
    
    // Link ShareSheet
    @State private var shareString: String = "https://github.com/scheuebe/UltimatePhotoJourney"
    
    // E-Mail for feedback
    @State private var email: String = "bernhard.scheuermann@uni-a.de"
    @State private var mailSubject: String = "Feedback%20to%20your%20application%20PhotoJourney"
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    // To create sample data
    var dataController: DataController

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Configuration")) {
                    NavigationLink { SettingsGeneral(title: "App Settings") } label: {
                        SettingsRow(pictureName: "gear", text: "App Settings", iconWidth: $iconWidth)
                    }
                    
                    NavigationLink { SettingsSlideshow(title: "Slideshow Settings") } label: {
                        SettingsRow(pictureName: "slider.horizontal.below.rectangle", text: "Slideshow Settings", iconWidth: $iconWidth)
                    }
                }
                
                // future work
                /*
                Section(header: Text("Payment")) {
                    NavigationLink { SettingsPlaceholder(title: "Subscription Plan") } label: {
                        SettingsRow(pictureName: "creditcard", text: "Subscription Plan", iconWidth: $iconWidth)
                    }
                    
                    NavigationLink { SettingsPlaceholder(title: "Restore Purchases") } label: {
                        SettingsRow(pictureName: "gift", text: "Restore purchases", iconWidth: $iconWidth)
                    }
                }
                .opacity(isDisabled ? 0.4 : 1)
                .disabled(isDisabled)
                */
                
                Section(header: Text("Sample data")) {
                    Button {
                        addSampleData()
                        alertMessage = "Created sample data :)"
                        showingAlert = true
                    } label: {
                        SettingsRow(pictureName: "photo.on.rectangle.angled", text: "Create Sample Data for me", iconWidth: $iconWidth)
                    }
                    
                    if name == "Bernhard Scheuermann" {
                        NavigationLink { SettingsSurvey(title: "Survey Data", alertMessage: $alertMessage, showingAlert: $showingAlert, dataController: dataController) } label: {
                            SettingsRow(pictureName: "doc", text: "Survey Data", iconWidth: $iconWidth)
                        }
                    }
                }

                Section(header: Text("Ultimate Photo Journey"), footer:
                    SettingsFooter()
                ) {
                    NavigationLink { SettingsPlaceholder(title: "Help") } label: {
                        SettingsRow(pictureName: "questionmark", text: "Help", iconWidth: $iconWidth)
                    }
                    .opacity(isDisabled ? 0.7 : 1)
                    .disabled(isDisabled)
                    
                    Button {
                        // more to come
                    } label: {
                        SettingsRow(pictureName: "star", text: "Rate the app", iconWidth: $iconWidth)
                    }
                    .opacity(isDisabled ? 0.4 : 1)
                    .disabled(isDisabled)
                    
                    Button {
                        if let url = URL(string: "mailto:\(email)?subject=\(mailSubject)") {
                          if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url)
                          } else {
                            UIApplication.shared.openURL(url)
                          }
                        }
                    } label: {
                        SettingsRow(pictureName: "exclamationmark.bubble", text: "Send feedback", iconWidth: $iconWidth)
                    }
                    
                    Button(action: actionSheet) {
                        SettingsRow(pictureName: "square.and.arrow.up", text: "Share with your friends", iconWidth: $iconWidth)
                    }
                    
                    NavigationLink { SettingsAbout(title: "About") } label: {
                        SettingsRow(pictureName: "house", text: "About", iconWidth: $iconWidth)
                    }
                }
                .navigationTitle("Settings")
                .alert(alertMessage, isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                }
            }
            
            /*if horizontalSizeClass == .regular {
                SettingsGeneral(title: "App Settings")
            }*/
        }
        .navigationViewStyle(.stack)
        .accentColor(.appColor)
    }
    
    func actionSheet() {
        guard let urlShare = URL(string: shareString) else { return }
        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
    
    func addSampleData() {
        // dataController.deleteAll()
        try? dataController.createSampleData()
    }
}
