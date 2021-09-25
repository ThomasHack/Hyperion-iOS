//
//  Adjustment.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public struct Adjustment: Equatable, Codable {
    public let brightness: Int

    public init(brightness: Int) {
        self.brightness = brightness
    }
}
