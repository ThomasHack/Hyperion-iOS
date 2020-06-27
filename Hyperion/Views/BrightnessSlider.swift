//
//  BrightnessSlider.swift
//  Hyperion
//
//  Created by Hack, Thomas on 13.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import SwiftUI

struct BrightnessSlider: View {

    @Binding var percentage: Double

    var callback: (() -> Void)?

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color(UIColor.tertiarySystemBackground).opacity(1.0))
                ZStack(alignment: .trailing) {
                    HStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(Color(UIColor.systemYellow)
                                // LinearGradient(gradient: Gradient(colors: [Color(UIColor.systemYellow).opacity(1.0), Color(UIColor.systemBackground).opacity(0.95)]), startPoint: .leading, endPoint: .trailing)
                            )
                    }.cornerRadius(12)
                        .clipped()
                    HStack {
                        Rectangle()
                            .frame(width: 4, height: 20, alignment: .trailing)
                            .foregroundColor(Color.white)
                            .cornerRadius(3)
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: -1, y: 1)
                    }.padding([.trailing], 6)
                }
                .frame(width: (geometry.size.width * CGFloat(self.percentage/100)) + CGFloat(16 * (100 - self.percentage)/100))
                .animation(.spring(response: 0.35, dampingFraction: 0.75, blendDuration: 0))

                HStack(alignment: .bottom, spacing: 2) {
                    Text("\(Int(self.percentage))")
                    .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color(UIColor.secondaryLabel))
                    Text("%")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color(UIColor.secondaryLabel))
                }.frame(maxWidth: .infinity, alignment: .center)
            }
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.2), radius: 2.0, x: 1, y: 1)
            .gesture(DragGesture(minimumDistance: 0)
            .onChanged({ value in
                self.percentage = Double(min(max(0, Float(value.location.x / geometry.size.width * 100)), 100))
                if let callback = self.callback {
                    callback()
                }
            }))
        }
    }
}

extension BrightnessSlider {
    func didChange(perform action: @escaping () -> Void ) -> Self {
        var copy = self
        copy.callback = action
        return copy
    }
}


struct BrightnessSlider_Previews: PreviewProvider {

    struct BindingTestHolder: View {
        @State var percentage: Double = 0
        var body: some View {
            BrightnessSlider(percentage: $percentage)
        }
    }

    static var previews: some View {
        BindingTestHolder()
            .frame(width: 320, height: 64, alignment: .center)
            .environment(\.colorScheme, .light)
    }
}
