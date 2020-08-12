//
//  IntensityButton.swift
//  Hyperion
//
//  Created by Hack, Thomas on 14.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import SwiftUI

struct InstanceButton: View {

    var imageName: String?
    var text: String

    var isDisabled = false
    var isRunning = false

    var callback: (() -> Void)

    var body: some View {
        Button(action: {
            if isDisabled { return }
            self.callback()
        }) {

            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    VStack(spacing: 0) {
                        if let imageName = imageName, imageName.count > 0 {
                            Image(imageName)
                                .resizable()
                                .padding(2)
                                .clipped()
                        } else {
                            Image(systemName: "rays")
                                .resizable()
                                .padding(10)
                                .clipped()
                        }
                    }
                    .frame(width: 36, height: 36)
                    .background(Color(hue: 0, saturation: 0, brightness: 0.95))
                    .cornerRadius(36)

                    Spacer()

                    if isRunning {
                        Circle()
                            .foregroundColor(.green)
                            .frame(width: 8, height: 8)
                            .offset(x: 0, y: 0)
                    }
                }

                Spacer().frame(minHeight: 8)

                Text(text)
                    .foregroundColor(isDisabled ? Color(UIColor.secondaryLabel) : Color(UIColor.label))
                    .font(.system(size: 13.0, weight: .semibold))
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)

                Text(isRunning ? "On" : "Off")
                    .foregroundColor(Color(UIColor.secondaryLabel))
                    .font(.system(size: 13.0, weight: .semibold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            }
        }
        .buttonStyle(DefaultButtonStyle(disabled: isDisabled))
    }
}

struct InstanceButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack(spacing: 16) {
                InstanceButton(
                    imageName: "Ambilight",
                    text: "Very Long Button Title",
                    isDisabled: false,
                    isRunning: true,
                    callback: {}
                )
                InstanceButton(
                    imageName: "Hue Sync",
                    text: "Button Title",
                    isDisabled: false,
                    isRunning: false,
                    callback: {}
                )
                InstanceButton(
                    imageName: "Play Lightbars",
                    text: "Very Long Button Title",
                    isDisabled: false,
                    isRunning: false,
                    callback: {}
                )
            }
            .padding(16)
        }
    }
}
