//
//  ButtonStyles.swift
//  Hyperion
//
//  Created by Hack, Thomas on 11.08.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import SwiftUI

struct DefaultButtonStyle: ButtonStyle {
    var disabled = false

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .padding(.vertical, 8)
            .padding(.horizontal, 8)
            .foregroundColor(disabled ? Color(UIColor.secondaryLabel) : Color(UIColor.label))
            .background(disabled ? Color(UIColor.tertiarySystemFill) : Color(UIColor.systemBackground))
            .cornerRadius(5)
            .shadow(color: configuration.isPressed ? Color.black.opacity(0.15) : Color.black.opacity(0.2), radius: 2.0, x: 1, y: 1)
            .animation(.easeInOut)
            .scaleEffect(configuration.isPressed ? CGSize(width: 0.975, height: 0.975) : CGSize(width: 1.0, height: 1.0), anchor: .center)
            .animation(.spring(response: 0.1, dampingFraction: 0.55, blendDuration: 0))
    }
}
