//
//  ColorData.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public struct ColorData: Equatable, Codable {
    public let color: [Int]
    public let priority: Int
    public let origin: String

    public init(color: [Int], priority: Int, origin: String) {
        self.color = color
        self.priority = priority
        self.origin = origin
    }
}
