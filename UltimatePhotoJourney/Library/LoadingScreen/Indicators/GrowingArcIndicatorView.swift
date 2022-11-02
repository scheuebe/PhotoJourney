//
//  GrowingArcIndicatorView.swift
//  ActivityIndicatorView
//
//  Created by Daniil Manin on 10/7/20.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

struct GrowingArcIndicatorView: View {

    let color: Color
    @State private var animatableParameter: Double = 0

    public var body: some View {
        let animation = Animation
            .easeIn(duration: 2)
            .repeatForever(autoreverses: false)

        return GrowingArc(path: animatableParameter)
            .stroke(color, lineWidth: 4)
            .onAppear {
                self.animatableParameter = 0
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    withAnimation(animation) {
                        self.animatableParameter = 1
                    }
                }
            }
    }
}

struct GrowingArc: Shape {

    var maxLength = 2 * Double.pi - 0.7
    var lag = 0.35
    var path: Double

    var animatableData: Double {
        get { return path }
        set { path = newValue }
    }

    func path(in rect: CGRect) -> Path {

        let height = path * 2
        var length = height * maxLength
        if height > 1 && height < lag + 1 {
            length = maxLength
        }
        if height > lag + 1 {
            let coeff = 1 / (1 - lag)
            let number = height - 1 - lag
            length = (1 - number * coeff) * maxLength
        }

        let first = Double.pi / 2
        let second = 4 * Double.pi - first

        var end = height * first
        if height > 1 {
            end = first + (height - 1) * second
        }

        let start = end + length

        var path = Path()
        path.addArc(center: CGPoint(x: rect.size.width/2, y: rect.size.width/2),
                 radius: rect.size.width/2,
                 startAngle: Angle(radians: start),
                 endAngle: Angle(radians: end),
                 clockwise: true)
        return path
    }
}
