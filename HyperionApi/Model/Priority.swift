//
//  Priority.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public struct Priority: Equatable, Decodable {
    public let active: Bool
    public let componentId: ComponentType
    public let origin: String
    public let priority: Int
    public let visible: Bool
    public let value: PriorityValue?

    public init(active: Bool, componentId: ComponentType, origin: String, priority: Int, visible: Bool, value: PriorityValue?) {
        self.active = active
        self.componentId = componentId
        self.origin = origin
        self.priority = priority
        self.visible = visible
        self.value = value
    }
}
