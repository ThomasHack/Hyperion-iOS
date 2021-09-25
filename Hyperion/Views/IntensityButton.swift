//
//  IntensityButton.swift
//  Hyperion
//
//  Created by Hack, Thomas on 14.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import SwiftUI

struct IntensityButton: View {

    var imageName: String
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
                ZStack(alignment: .topLeading) {
                    Image(systemName: imageName).font(.title)

                    if isRunning {
                        HStack(alignment: .top) {
                            Spacer()
                            VStack(alignment: .trailing) {
                                Circle()
                                    .foregroundColor(.green)
                                    .frame(width: 8, height: 8)
                                Spacer()
                            }
                        }
                    }
                }

                Spacer().frame(minHeight: 8)

                Text(text)
                    .foregroundColor(isDisabled ? Color(UIColor.secondaryLabel) : Color(UIColor.label))
                    .font(.system(size: 13.0, weight: .semibold))
                    .frame(minHeight: 30)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding([.top, .bottom], 8)
            .padding([.leading, .trailing], 8)
        }.buttonStyle(CardButtonStyle(disabled: isDisabled))
    }
}

struct IntensityButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack(spacing: 16) {
                IntensityButton(
                    imageName: "rays",
                    text: "Very Long Button Title",
                    isDisabled: false,
                    isRunning: false,
                    callback: {}
                )
                IntensityButton(
                    imageName: "rays",
                    text: "Button Title",
                    isDisabled: false,
                    isRunning: false,
                    callback: {}
                )
                IntensityButton(
                    imageName: "rays",
                    text: "Very Long Button Title",
                    isDisabled: false,
                    isRunning: true,
                    callback: {}
                )
            }
            .padding(16)
            Spacer().frame(height: 16)
            HStack(spacing: 16) {
                IntensityButton(
                    imageName: "rays",
                    text: "Standard",
                    isDisabled: false,
                    isRunning: false,
                    callback: {}
                )
                IntensityButton(
                    imageName: "rays",
                    text: "Disabled",
                    isDisabled: true,
                    isRunning: false,
                    callback: {}
                )
                IntensityButton(
                    imageName: "rays",
                    text: "Running",
                    isDisabled: false,
                    isRunning: true,
                    callback: {}
                )
            }
            .padding(16)
        }
        .frame(width: 375, height: 280, alignment: .center)
    }
}
