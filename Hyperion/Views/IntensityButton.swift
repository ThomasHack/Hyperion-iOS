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
        Button(action: {
            self.callback()
        }) {
            VStack {
                HStack {
                    Image(systemName: imageName)
                        .font(.title)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .padding([.top, .bottom], 14)
                .foregroundColor(Color(UIColor.label))
                .background(Color(running ? UIColor.systemBackground : UIColor.secondarySystemBackground))
                .cornerRadius(5)
                .shadow(color: Color.black.opacity(0.2), radius: 2.0, x: 1, y: 1)

                Text(text)
                    .foregroundColor(Color(UIColor.label))
                    .font(.system(size: 13.0, weight: .semibold))
            }
        }
    }
}

struct IntensityButton_Previews: PreviewProvider {
    static var previews: some View {
        IntensityButton(imageName: "rays", text: "Subtle", callback: {})
            .frame(width: 84, height: 64, alignment: .center)
    }
}
