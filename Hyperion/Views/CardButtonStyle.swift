//
//  CardButtonStyle.swift
//  Hyperion
//
//  Created by Hack, Thomas on 11.08.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import SwiftUI

struct CardButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled

    var active = false

    func makeBody(configuration: Self.Configuration) -> some View {
        let background = Color(UIColor.secondarySystemBackground).opacity(isEnabled && active ? 1.0 : 0.6)

        let foreground = isEnabled ? Color(UIColor.label) : Color(UIColor.secondaryLabel)

        var size: CGSize {
            configuration.isPressed && isEnabled ? CGSize(width: 0.975, height: 0.975) : CGSize(width: 1.0, height: 1.0)
        }

        return configuration.label
            .foregroundColor(foreground)
            .background(background)
            .cornerRadius(15)
            .animation(.easeInOut)
            .scaleEffect(size, anchor: .center)
            .animation(.spring(response: 0.1, dampingFraction: 0.55, blendDuration: 0))
    }
}
