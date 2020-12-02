//
//  Color.swift
//  Hyperion
//
//  Created by Hack, Thomas on 17.08.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import UIKit
import SwiftUI

extension Color {

    var rgbColor: RGB {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        guard UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return RGB(red: 0, green: 0, blue: 0)
        }
        return RGB(red: red, green: green, blue: blue)
    }
}
