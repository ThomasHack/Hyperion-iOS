//
//  Appearance.swift
//  Hyperion
//
//  Created by Hack, Thomas on 13.08.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import UIKit

enum Appearance {

    static var standardAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.shadowColor = .clear
        return appearance
    }()

    static var whiteAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.shadowColor = .clear
        return appearance
    }()

    static var transparentAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        return appearance
    }()

    static func style() {}
}
