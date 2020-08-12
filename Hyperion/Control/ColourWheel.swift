//
//  ColourWheel.swift
//  Hyperion
//
//  Created by Hack, Thomas on 02.07.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import SwiftUI

struct ColourWheel: View {

    var radius: CGFloat

    @Binding var rgbColour: RGB
    @Binding var brightness: CGFloat

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CIHueSaturationValueGradientView(
                    radius: geometry.size.width,
                    brightness: self.$brightness
                )

                RadialGradient(gradient: Gradient(
                                colors: [Color.white.opacity(0.8*Double(self.brightness)), .clear]),
                               center: .center,
                               startRadius: 0,
                               endRadius: geometry.size.width/2
                )
                .blendMode(.screen)

                Circle()
                    .frame(width: 20, height: 20)
                    .offset(x: (geometry.size.width/2 - 10) * self.rgbColour.hsv.s)
                    .rotationEffect(.degrees(-Double(self.rgbColour.hsv.h)))
                    .foregroundColor(
                        Color(
                            UIColor(
                                red: self.rgbColour.r,
                                green: self.rgbColour.g,
                                blue: self.rgbColour.b,
                                alpha: 1.0)
                        )
                    )
                    .shadow(color: Color.black.opacity(0.3), radius: 2, x: 1, y: 1)

            }
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .global)
                    .onChanged { value in
                        let y = geometry.frame(in: .global).midY - value.location.y
                        let x = value.location.x - geometry.frame(in: .global).midX
                        let hue = atan2To360(atan2(y, x))
                        let center = CGPoint(x: geometry.frame(in: .global).midX, y: geometry.frame(in: .global).midY)
                        let saturation = min(distance(center, value.location)/(self.radius/2), 1)
                        self.rgbColour = HSV(h: hue, s: saturation, v: self.brightness).rgb
                    }
            )
        }
        .frame(width: self.radius, height: self.radius)
        .onAppear {
            self.rgbColour = HSV(h: self.rgbColour.hsv.h, s: self.rgbColour.hsv.s, v: self.brightness).rgb
        }
    }
}

struct ColourWheel_Previews: PreviewProvider {
    struct ColourWheel_PreviewWrapper: View {

        @State(initialValue: RGB(r: 1, g: 1, b: 1)) var rgbColour: RGB
        @State(initialValue: 1.0) var brightness: CGFloat

        var body: some View {
            ColourWheel(radius: 350, rgbColour: $rgbColour, brightness: $brightness)
        }
      }

    static var previews: some View {
        ColourWheel_PreviewWrapper()
    }
}
