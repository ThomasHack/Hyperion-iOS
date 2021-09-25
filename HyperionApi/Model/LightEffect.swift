//
//  LightEffect.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public struct LightEffect: Equatable, Codable, Hashable {
    public let name: String

    public init(name: String) {
        self.name = name
    }
}
