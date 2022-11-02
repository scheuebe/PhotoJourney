//
//  AwardsView.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 12.01.22.
//

import SwiftUI

struct AwardsView: View {
    static let tag: String? = "Awards"

    @EnvironmentObject var dataController: DataController
    @State private var selectedAward = Award.example
    @State private var showingAwardDetails = false

    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 60, maximum: 60))]
    }

    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(Award.allAwards) { award in
                Button {
                    selectedAward = award
                    showingAwardDetails = true
                } label: {
                    Image(systemName: award.image)
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .frame(width: 60, height: 60)
                        .foregroundColor(color(for: award))
                }
                .accessibilityLabel(label(for: award))
                .accessibility(hint: Text(award.description))
            }
        }
        .alert(isPresented: $showingAwardDetails, content: getAwardAlert)
    }
    
    func color(for award: Award) -> Color {
        dataController.hasEarned(award: award) ? Color(award.color) : Color.secondary.opacity(0.5)
    }
    
    func label(for award: Award) -> Text {
        Text(dataController.hasEarned(award: award) ? "Unlocked: \(award.name)" : "Locked")
    }
    
    func getAwardAlert() -> Alert {
        if dataController.hasEarned(award: selectedAward) {
            return Alert(
                title: Text("Unlocked \(selectedAward.name)"),
                message: Text(selectedAward.description),
                dismissButton: .default(Text("OK"))
            )
        } else {
            return Alert(
                title: Text("Locked"),
                message: Text(selectedAward.description),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct AwardsView_Previews: PreviewProvider {
    static var previews: some View {
        AwardsView()
    }
}