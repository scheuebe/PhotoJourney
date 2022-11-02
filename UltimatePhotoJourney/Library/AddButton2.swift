//
//  AddButton.swift
//  PhotoJourney
//
//  Created by Bernhard Scheuermann on 23.02.21.
//

import SwiftUI

struct AddButton2: View {
    var body: some View {
        ZStack {
            /*Image(systemName: "ellipsis").imageScale(.large)
                .foregroundColor(.black)
                .padding()
                .background(Color.red)
                .clipShape(Circle())*/
            Image(systemName: "ellipsis.circle.fill").imageScale(.large)
                .foregroundColor(Color.white)
                .background(Color.appColor)
                // .frame(width: width.self, height: self, alignment: .center)
                .clipShape(Circle())
        }
    }
}

struct AddButton2_Previews: PreviewProvider {
    static var previews: some View {
        AddButton2()
    }
}
