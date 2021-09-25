//
//  EffectData.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public struct EffectData: Equatable, Codable {
    public let effect: LightEffect
    public let priority: Int
    public let origin: String

    public init(effect: LightEffect, priority: Int, origin: String) {
        self.effect = effect
        self.priority = priority
        self.origin = origin
    }
}
