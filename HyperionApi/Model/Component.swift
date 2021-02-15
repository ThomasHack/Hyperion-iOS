//
//  Component.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public struct Component: Equatable, Decodable {
    public let name: ComponentType
    public let enabled: Bool

    public init(name: ComponentType, enabled: Bool) {
        self.name = name
        self.enabled = enabled
    }
}
