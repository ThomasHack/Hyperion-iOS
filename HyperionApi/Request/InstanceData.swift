//
//  InstanceData.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public struct InstanceData: Equatable, Codable {
    public let subcommand: SubCommandType
    public let instance: Int

    public init(subcommand: SubCommandType, instance: Int) {
        self.subcommand = subcommand
        self.instance = instance
    }
}
