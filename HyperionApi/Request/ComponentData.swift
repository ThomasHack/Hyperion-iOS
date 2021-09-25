//
//  ComponentData.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public struct ComponentData: Equatable, Codable {
    public let componentstate: ComponentState

    public init (componentstate: ComponentState) {
        self.componentstate = componentstate
    }
}
