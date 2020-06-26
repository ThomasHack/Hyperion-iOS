//
//  ApiResponse.swift
//  Hyperion
//
//  Created by Hack, Thomas on 26.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import Foundation

struct ServerInfo: Codable {
    let instances: [InstanceData]
    let hostname: String
    let adjustment: [AdjustmentData]

    enum CodingKeys: String, CodingKey {
        case instances = "instance"
        case hostname = "hostname"
        case adjustment = "adjustment"
    }
}

struct InstanceData: Codable, Identifiable, Equatable {
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
    let brightness: Double

    enum CodingKeys: String, CodingKey {
        case brightness = "brightness"
    }
}

struct ApiResponse: Codable {
    let command: ApiTopic
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
