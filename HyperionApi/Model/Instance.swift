//
//  Instance.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public struct Instance: Equatable, Decodable, Hashable {
    public let instance: Int
    public let running: Bool
    public let friendlyName: String

    enum CodingKeys: String, CodingKey {
        case instance = "instance"
        case running = "running"
        case friendlyName = "friendly_name"
    }

    public init(instance: Int, running: Bool, friendlyName: String) {
        self.instance = instance
        self.running = running
        self.friendlyName = friendlyName
    }
}
