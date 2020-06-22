//
//  APIResponse.swift
//  Hyperion
//
//  Created by Hack, Thomas on 13.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import Foundation

enum CommandType: String, Codable {
    case serverInfo = "serverinfo"
    case adjustment = "adjustment"
    case adjustmentUpdate = "adjustment-update"
    case instanceUpdate = "instance-update"
}

struct ServerInfo: Codable {
    let instances: [Instance]
    let hostname: String
    let adjustment: [AdjustmentData]

    enum CodingKeys: String, CodingKey {
        case instances = "instance"
        case hostname = "hostname"
        case adjustment = "adjustment"
    }
}

struct Instance: Codable, Identifiable, Equatable {
    let id: Int
    let friendlyName: String
    let running: Bool

    enum CodingKeys: String, CodingKey {
        case id = "instance"
        case friendlyName = "friendly_name"
        case running = "running"
    }
}

struct AdjustmentData: Codable {
    let brightness: Int

    enum CodingKeys: String, CodingKey {
        case brightness = "brightness"
    }
}

struct APIResponse: Codable {
    let command: CommandType
    let data: [AdjustmentData]?
    let success: Bool?
    let info: ServerInfo?

    enum CodingKeys: String, CodingKey {
        case command = "command"
        case data = "data"
        case success = "success"
        case info = "info"
    }
}
