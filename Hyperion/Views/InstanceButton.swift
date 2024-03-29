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
        Button {
            if isDisabled { return }
            self.callback()
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    VStack(spacing: 0) {
                        if let imageName = imageName, !imageName.isEmpty {
                            Image(imageName)
                                .resizable()
                                .clipped()
                        } else {
                            Image(systemName: "rays")
                                .resizable()
                                .padding(6)
                                .clipped()
                        }
                    }
                    .frame(width: 42, height: 42)

                    Spacer()

                    if isRunning {
                        Circle()
                            .foregroundColor(.green)
                            .frame(width: 8, height: 8)
                    }
                }

                Spacer(minLength: 8)

                VStack(spacing: 0) {
                    Text(text)
                        .foregroundColor(isDisabled ? Color(UIColor.secondaryLabel) : Color(UIColor.label))
                        .font(.system(size: 13.0, weight: .semibold))
                        .lineLimit(2)
                        .frame(minHeight: 30)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(8)
        }
        .disabled(isDisabled)
        .buttonStyle(CardButtonStyle(active: isRunning))
    }
}

struct InstanceButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack(spacing: 16) {
                InstanceButton(
                    imageName: "ambilight",
                    text: "Very Long Button Title",
                    isDisabled: false,
                    isRunning: true,
                    callback: {}
                )
                InstanceButton(
                    imageName: "hue-lightstrip",
                    text: "Button Title",
                    isDisabled: false,
                    isRunning: false,
                    callback: {}
                )
                InstanceButton(
                    imageName: "",
                    text: "Very Long Button Title",
                    isDisabled: false,
                    isRunning: false,
                    callback: {}
                )
            }
            .padding(16)
        }
        .previewLayout(.fixed(width: 375, height: 140))
    }
}
