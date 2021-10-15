//
//  BlurVie.swift
//  Hyperion
//
//  Created by Hack, Thomas on 13.08.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import SwiftUI
import UIKit

struct BlurView: UIViewRepresentable {
    typealias UIViewType = UIVisualEffectView

    let style: UIBlurEffect.Style

    init(style: UIBlurEffect.Style = .systemChromeMaterial) {
        self.style = style
    }

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: self.style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: self.style)
    }
}
