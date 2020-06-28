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
    var running: Bool = true
    var callback: (() -> Void)

    var body: some View {
        VStack {
            Button(action: { self.callback() }) {
                Image(systemName: imageName).font(.title)
            }
            .buttonStyle(DefaultButtonStyle())
            .background(Color(running ? UIColor.systemBackground : UIColor.secondarySystemBackground))

            Text(text)
                .foregroundColor(Color(UIColor.label))
                .font(.system(size: 13.0, weight: .semibold))
        }
    }
}

struct DefaultButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding([.top, .bottom], 14)
            .foregroundColor(Color(UIColor.label))
            .background(Color(UIColor.systemBackground))
            .cornerRadius(5)
            .shadow(color: configuration.isPressed ? Color.black.opacity(0.15) : Color.black.opacity(0.2), radius: 2.0, x: 1, y: 1)
            .animation(.easeInOut)
            .scaleEffect(configuration.isPressed ? CGSize(width: 0.975, height: 0.975) : CGSize(width: 1.0, height: 1.0), anchor: .center)
            .animation(.spring(response: 0.1, dampingFraction: 0.55, blendDuration: 0))
    }
}

struct IntensityButton_Previews: PreviewProvider {
    static var previews: some View {
        IntensityButton(imageName: "rays", text: "Subtle", callback: {})
            .frame(width: 84, height: 64, alignment: .center)
    }
}
