//
//  ResponseInstanceInfo.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public struct InstanceInfo: Decodable {
    public let instance: Int

    public init(instance: Int) {
        self.instance = instance
    }
}
