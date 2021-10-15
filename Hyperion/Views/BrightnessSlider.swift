//
//  BrightnessControlSlider.swift
//  Hyperion
//
//  Created by Hack, Thomas on 13.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import SwiftUI

struct BrightnessSlider: View {
    @Environment(\.isEnabled) var isEnabled
    @Binding var percentage: Double

    var callback: (() -> Void)?

    var body: some View {
        GeometryReader { geometry in

            let horizontalPadding: CGFloat = 3
            let verticalPadding: CGFloat = 3
            let grabberWidth: CGFloat = 16
            let percentageWidth: CGFloat = geometry.size.width * CGFloat(self.percentage / 100)
            let minWidth = CGFloat(grabberWidth * (100 - self.percentage) / 100)
            let maxWidth = CGFloat(2 * horizontalPadding * (self.percentage) / 100)
            let barWidth: CGFloat = percentageWidth + minWidth - maxWidth
            let barHeight: CGFloat = geometry.size.height - 2 * verticalPadding

            ZStack(alignment: .leading) {
                // Background
                Rectangle()
                    .foregroundColor(Color(.secondarySystemBackground))
                    .opacity(isEnabled ? 1.0 : 0.6)

                ZStack(alignment: .trailing) {
                    // Progressbar
                    HStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(Color(.systemBackground))
                            .opacity(isEnabled ? 1.0 : 0.8)
                    }
                    .cornerRadius(12)
                    .clipped()

                    // Grabber
                    HStack {
                        Rectangle()
                            .frame(width: 4, height: 20, alignment: .trailing)
                            .foregroundColor(Color.secondary)
                            .opacity(isEnabled ? 1.0 : 0.6)
                            .cornerRadius(3)
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: -1, y: 1)
                    }
                    .padding([.trailing], 6)
                }
                .offset(x: verticalPadding, y: 0)
                .frame(width: barWidth, height: barHeight)
                .animation(.spring(response: 0.35, dampingFraction: 0.75, blendDuration: 0))

                // Label
                HStack(alignment: .bottom, spacing: 2) {
                    Text("\(Int(self.percentage))")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color(UIColor.secondaryLabel))
                    Text("%")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(UIColor.secondaryLabel))
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }

            .clipped()
            .cornerRadius(15)
            .gesture(DragGesture(minimumDistance: 0)
            .onChanged({ value in
                guard isEnabled else { return }
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

struct BrightnessControlSlider_Previews: PreviewProvider {

    struct BindingTestHolder: View {
        @State var percentage: Double = 100
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
