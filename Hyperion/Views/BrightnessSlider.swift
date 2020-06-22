//
//  BrightnessSlider.swift
//  Hyperion
//
//  Created by Hack, Thomas on 13.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import SwiftUI

struct BrightnessSlider: View {

    @Binding var percentage: Int

    var callback: (() -> Void)?

    var body: some View {
        GeometryReader { geometry in
            // TODO: - there might be a need for horizontal and vertical alignments
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color(UIColor.tertiarySystemBackground).opacity(0.90))
                ZStack(alignment: .trailing) {
                    HStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(LinearGradient(gradient:
                                Gradient(colors: [Color(UIColor.systemGray6).opacity(0.2), Color(UIColor.systemGray4)
                                    .opacity(0.95)]), startPoint: .leading, endPoint: .trailing))
                    }.cornerRadius(12)
                        .clipped()
                    HStack {
                        Rectangle()
                            .frame(width: 4, height: 20, alignment: .trailing)
                            .foregroundColor(Color.gray)
                            .cornerRadius(3)
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: -1, y: 1)
                    }.padding([.trailing], 6)
                }.frame(width: geometry.size.width * CGFloat(self.percentage / 100))

            }
            .cornerRadius(12)
            .gesture(DragGesture(minimumDistance: 0)
            .onChanged({ value in
                // TODO: - maybe use other logic here
                self.percentage = Int(min(max(0, Float(value.location.x / geometry.size.width * 100)), 100))
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
        @State var percentage: Int = 65
        var body: some View {
            BrightnessSlider(percentage: $percentage)
        }
    }

    static var previews: some View {
        BindingTestHolder()
            .frame(width: 320, height: 64, alignment: .center)
    }
}
