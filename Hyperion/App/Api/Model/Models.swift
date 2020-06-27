//
//  ApiResponse.swift
//  Hyperion
//
//  Created by Hack, Thomas on 26.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import Foundation

// MARK: - Request

struct ApiRequest: Equatable, Codable {
    var command: ApiRequestCommandType
}

enum ApiRequestCommandType: String, Codable {
    case instance = "instance"
    case serverinfo = "serverinfo"
    case adjustment = "adjustment"
}

enum ApiRequestSubCommandType: String, Codable {
    case startInstance = "startInstance"
    case stopInstance = "stopInstance"
    case switchTo = "switchTo"
}

enum ApiSubscribeType: String, Codable {
    case adjustmentUpdate = "adjustment-update"
    case instanceUpdate = "instance-update"
}

struct ApiInstanceRequestData: Equatable, Codable {
    var subcommand: ApiRequestSubCommandType
    var instance: Int
}

struct ApiSubscribeRequestData: Equatable, Codable {
    var subscribe: [ApiSubscribeType]
}

struct ApiAdjustmentRequestData: Equatable, Codable {
    var adjustment: Adjustment
}

typealias ApiInstanceRequest = Compose<ApiRequest, ApiInstanceRequestData>
typealias ApiSubscribeRequest = Compose<ApiRequest, ApiSubscribeRequestData>
typealias ApiAdjustmentRequest = Compose<ApiRequest, ApiAdjustmentRequestData>

// MARK: - Response

enum ApiResponseType: String, Decodable {
    case serverInfo = "serverinfo"
    case instanceUpdate = "instance-update"
    case adjustmentUpdate = "adjustment-update"
    case adjustmentResponse = "adjustment"
    case instanceSwitch = "instance-switchTo"
    case instanceStop = "instance-stopInstance"
    case instanceStart = "instance-startInstance"
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let command = try container.decode(String.self)
        self = ApiResponseType(rawValue: command) ?? .unknown
    }
}

enum ApiResponse: Decodable {
    case serverInfo(ApiResponseServerInfo)
    case instanceUpdate(ApiResponseInstanceUpdate)
    case adjustmentUpdate(ApiResponseAdjustmentUpdate)
    case adjustmentResponse(ApiResponseSucess)
    case instanceSwitch(ApiResponseInstanceSwitch)
    case instanceStop(ApiResponseSucess)
    case instanceStart(ApiResponseSucess)
    case unknown

    enum CodingKeys: String, CodingKey {
        case command
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard
            let command = try? container.decode(ApiResponseType.self, forKey: .command) else {
                self = .unknown
                return
        }
        let data = try decoder.singleValueContainer()
        switch command {
        case .serverInfo:
            let update = try data.decode(ApiResponseServerInfo.self)
            self = .serverInfo(update)
        case .instanceUpdate:
            let update = try data.decode(ApiResponseInstanceUpdate.self)
            self = .instanceUpdate(update)
        case .adjustmentUpdate:
            let update = try data.decode(ApiResponseAdjustmentUpdate.self)
            self = .adjustmentUpdate(update)
        case .instanceSwitch:
            let update = try data.decode(ApiResponseInstanceSwitch.self)
            self = .instanceSwitch(update)
        case .adjustmentResponse, .instanceStart, .instanceStop:
            let update = try data.decode(ApiResponseSucess.self)
            self = .adjustmentResponse(update)
        case .unknown:
            self = .unknown
        }
    }
}

struct ApiResponseServerInfo: Decodable {
    var info: InfoData
}

struct ApiResponseInstanceUpdate: Decodable {
    var data: [Instance]
}

struct ApiResponseInstanceSwitch: Decodable {
    var info: ApiResponseInstanceInfo
    var success: Bool
}

struct ApiResponseAdjustmentUpdate: Decodable {
    var data: [Adjustment]
}

struct ApiResponseSucess: Decodable {
    var success: Bool
}

struct ApiResponseInstanceInfo: Decodable {
    var instance: Int
}

struct InfoData: Equatable, Decodable {
    var adjustments: [Adjustment]
    var instances: [Instance]
    var hostname: String

    enum CodingKeys: String, CodingKey {
        case adjustments = "adjustment"
        case instances = "instance"
        case hostname = "hostname"
    }
}

struct Adjustment: Equatable, Codable {
    var brightness: Int
}

struct Instance: Equatable, Decodable, Hashable {
    var instance: Int
    var running: Bool
    var friendlyName: String

    enum CodingKeys: String, CodingKey {
        case instance = "instance"
        case running = "running"
        case friendlyName = "friendly_name"
    }
}
