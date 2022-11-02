//
//  ChangelogView.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 27.08.22.
//

import SwiftUI

struct ChangelogView: View {
    var title: String = ""
    
    var body: some View {
        List {
            ForEach(changeLog.reversed(), id: \.id) { change in
                Section(header: Text("\(change.date)")) {
                    VStack(alignment: .leading) {
                        Text("Version \(change.id)")
                            .font(.title2)
                            .padding(.vertical, 2)
                        
                        Text(change.features)
                            .padding(.bottom, 8)
                    }
                }
            }
        }
        .padding(.bottom, 30)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChangelogView_Previews: PreviewProvider {
    static var previews: some View {
        ChangelogView()
    }
}
