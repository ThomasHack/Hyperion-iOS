//
//  ComponentState.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public struct ComponentState: Equatable, Codable {
    public let component: ComponentType
    public let state: Bool

    public init(component: ComponentType, state: Bool) {
        self.component = component
        self.state = state
    }
}
