//
//  CustomSlider.swift
//  Hyperion
//
//  Created by Hack, Thomas on 02.07.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import SwiftUI

struct CustomSlider: View {

    @Binding var rgbColour: RGB
    @Binding var value: CGFloat

    @State var lastOffset: CGFloat = 0
    @State var isTouchingKnob = false

    var range: ClosedRange<CGFloat>
    var leadingOffset: CGFloat = 8
    var trailingOffset: CGFloat = 8

    var knobSize: CGSize = CGSize(width: 28, height: 28)

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(
                        Color.init(
                            red: Double(self.rgbColour.r),
                            green: Double(self.rgbColour.g),
                            blue: Double(self.rgbColour.b)
                        )
                    )
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color.white, lineWidth: self.isTouchingKnob ? 4 : 5)
                            .frame(width: self.knobSize.width, height: self.knobSize.height)

                        RoundedRectangle(cornerRadius: 50)
                            .frame(width: self.knobSize.width, height: self.knobSize.height)
                            .foregroundColor(
                                Color.init(
                                    red: Double(self.rgbColour.r-0.1),
                                    green: Double(self.rgbColour.g-0.1),
                                    blue: Double(self.rgbColour.b-0.1)
                                )
                            )
                    }
                    .offset(
                        x: self.$value.wrappedValue.map(
                            from: self.range,
                            to: self.leadingOffset...(geometry.size.width - self.knobSize.width - self.trailingOffset)
                        )
                    )
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                self.isTouchingKnob = true
                                if abs(value.translation.width) < 0.1 {
                                    self.lastOffset = self.$value.wrappedValue.map(from: self.range, to: self.leadingOffset...(geometry.size.width - self.knobSize.width - self.trailingOffset))
                                }
                                let sliderPos = max(0 + self.leadingOffset, min(self.lastOffset + value.translation.width, geometry.size.width - self.knobSize.width - self.trailingOffset))
                                let sliderVal = sliderPos.map(from: self.leadingOffset...(geometry.size.width - self.knobSize.width - self.trailingOffset), to: self.range)

                                self.value = sliderVal
                            }
                            .onEnded { _ in
                                self.isTouchingKnob = false
                            }
                    )
                    Spacer()
                }
            }
        }
        .frame(height: 40)
    }
}

struct CustomSlider_Previews: PreviewProvider {
    static var previews: some View {
        CustomSlider(rgbColour: .constant(RGB(r: 0.5, g: 0.1, b: 0.9)), value: .constant(10), range: 1...100)
            .previewLayout(.fixed(width: 375, height: 50))
    }
}
