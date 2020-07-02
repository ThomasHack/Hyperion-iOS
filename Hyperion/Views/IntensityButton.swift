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
        VStack(alignment: .center, spacing: 8) {
            Button(action: {
                if isDisabled { return }
                self.callback()
            }) {
                ZStack {
                    VStack {
                        Image(systemName: imageName).font(.title)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.all, 24)
                    if isRunning {
                        HStack(alignment: .top) {
                            Spacer()
                            VStack(alignment: .trailing) {
                                Circle()
                                    .foregroundColor(.green)
                                    .frame(width: 8, height: 8)
                                    .offset(x: 0, y: 0)
                                Spacer()
                            }.padding(8)
                        }
                    }
                }
            }
            .buttonStyle(DefaultButtonStyle(disabled: isDisabled, running: isRunning))

            Text(text)
                .foregroundColor(isDisabled ? Color(UIColor.secondaryLabel) : Color(UIColor.label))
                .font(.system(size: 13.0, weight: .semibold))
        }
    }
}

struct DefaultButtonStyle: ButtonStyle {
    var disabled = false
    var running = false

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding([.top, .bottom], 0)
            .foregroundColor(disabled ? Color(UIColor.secondaryLabel) : Color(UIColor.label))
            .background(disabled ? Color(UIColor.tertiarySystemFill)
                            : Color(UIColor.systemBackground))
            .cornerRadius(5)
            .shadow(color: configuration.isPressed ? Color.black.opacity(0.15) : Color.black.opacity(0.2), radius: 2.0, x: 1, y: 1)
            .animation(.easeInOut)
            .scaleEffect(configuration.isPressed ? CGSize(width: 0.975, height: 0.975) : CGSize(width: 1.0, height: 1.0), anchor: .center)
            .animation(.spring(response: 0.1, dampingFraction: 0.55, blendDuration: 0))
    }
}

struct IntensityButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack() {
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
        .frame(width: 184, height: 400, alignment: .center)
    }
}
