//
//  ApiRequest.swift
//  Hyperion
//
//  Created by Hack, Thomas on 26.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import Foundation

enum ApiTopic: String, Codable {
    case serverInfo = "serverinfo"
    case adjustment = "adjustment"
    case adjustmentUpdate = "adjustment-update"
    case instanceUpdate = "instance-update"
}

struct ApiRequest: Codable {
    let command: ApiTopic
    let subscribe: [ApiTopic]?
    let adjustment: AdjustmentData?
    let tan: Int = 1

    init(command: ApiTopic, subscribe: [ApiTopic]) {
        self.command = command
        self.subscribe = subscribe
        self.adjustment = nil
    }

    init(command: ApiTopic, adjustment: AdjustmentData) {
        self.command = command
        self.adjustment = adjustment
        self.subscribe = nil
    }
}
