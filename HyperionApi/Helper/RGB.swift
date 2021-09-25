//
//  RGB.swift
//  Hyperion
//
//  Created by Hack, Thomas on 17.08.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import UIKit

public struct RGB: Equatable{
    public var red: CGFloat
    public var green: CGFloat
    public var blue: CGFloat

    public init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.red = red
        self.green = green
        self.blue = blue
    }
}
