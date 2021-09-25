//
//  ResponseInstanceSwitch.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public struct InstanceSwitchUpdate: Decodable {
    public let info: InstanceInfo
    public let success: Bool

    public init(info: InstanceInfo, success: Bool) {
        self.info = info
        self.success = success
    }
}
