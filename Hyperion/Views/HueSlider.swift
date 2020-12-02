//
//  HueSlider.swift
//  Hyperion
//
//  Created by Hack, Thomas on 14.08.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import SwiftUI

struct HueSlider: View {

    @Binding var value: CGFloat
    @Binding var hue: CGFloat
    @Binding var saturation: CGFloat
    @Binding var brightness: CGFloat

    var colors: [Color] = []

    let valueRange: ClosedRange<CGFloat> = 0.00...1.00
    let size = CGSize(width: 32, height: 32)
    var leadingOffset: CGFloat = 3
    var trailingOffset: CGFloat = -2

    var body: some View {
        GeometryReader { geometry in

            let minRange = leadingOffset
            let maxRange = max(leadingOffset, geometry.size.width - trailingOffset - size.width)
            let geometryRange = minRange...maxRange

            ZStack(alignment: .leading) {
                LinearGradient(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing)
                    .frame(width: geometry.size.width, height: size.height)
                    .cornerRadius(size.height/2)

                ZStack {
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 0)
                        .frame(width: size.width - 5, height: size.height - 5)

                    Circle()
                        .foregroundColor(Color(hue: Double(hue), saturation: Double(saturation), brightness: Double(brightness)))
                        .frame(width: size.width - 8, height: size.height - 8)
                }
                .offset(x: self.value.map(from: valueRange, to: geometryRange), y: 0)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged({ value in
                            let transformed = max(minRange, min(value.location.x, maxRange))
                            self.value = transformed.map(from: geometryRange, to: valueRange)
                        })
                )
            }
        }
        .frame(height: 32)
    }
}

struct HueSlider_Previews: PreviewProvider {
    struct BindingTestHolder: View {
        @State var hue: CGFloat = 0
        @State var saturation: CGFloat = 0
        @State var brightness: CGFloat = 0
        var body: some View {
            HueSlider(value: $hue, hue: $hue, saturation: $saturation, brightness: $brightness)
        }
    }

    static var previews: some View {
        BindingTestHolder()
    }
}
