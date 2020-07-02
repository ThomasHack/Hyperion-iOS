//
//  HyperionApi.swift
//  Hyperion
//
//  Created by Hack, Thomas on 26.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import Foundation

// MARK: - Request

enum HyperionApi {

    struct Request: Equatable, Codable {
        var command: RequestCommandType
    }

    enum RequestCommandType: String, Codable {
        case instance = "instance"
        case serverinfo = "serverinfo"
        case adjustment = "adjustment"
        case component = "componentstate"
        case color = "color"
        case effect = "effect"
        case clear = "clear"
    }

    enum RequestSubCommandType: String, Codable {
        case startInstance = "startInstance"
        case stopInstance = "stopInstance"
        case switchTo = "switchTo"
    }

    enum SubscribeType: String, Codable {
        case adjustmentUpdate = "adjustment-update"
        case instanceUpdate = "instance-update"
        case componentUpdate = "components-update"
    }

    struct InstanceRequestData: Equatable, Codable {
        var subcommand: RequestSubCommandType
        var instance: Int
    }

    struct SubscribeRequestData: Equatable, Codable {
        var subscribe: [SubscribeType]
    }

    struct AdjustmentRequestData: Equatable, Codable {
        var adjustment: Adjustment
    }

    struct ComponentRequestData: Equatable, Codable {
        var componentstate: ComponentState
    }

    struct ColorRequestData: Equatable, Codable {
        var color: [Int]
        var priority: Int
        var origin: String
    }

    struct EffectRequestData: Equatable, Codable {
        var effect: Effect
        var priority: Int
        var origin: String
    }

    struct ClearRequestData: Equatable, Codable {
        var priority: Int
    }

    struct ComponentState: Equatable, Codable {
        var component: ComponentType
        var state: Bool
    }

    enum ComponentType: String, Equatable, Codable {
        case all = "ALL"
        case smoothing = "SMOOTHING"
        case blackborder = "BLACKBORDER"
        case forwarder = "FORWARDER"
        case boblight = "BOBLIGHTSERVER"
        case grabber = "GRABBER"
        case v4l = "V4L"
        case led = "LEDDEVICE"
    }

    typealias InstanceRequest = Compose<Request, InstanceRequestData>
    typealias SubscribeRequest = Compose<Request, SubscribeRequestData>
    typealias AdjustmentRequest = Compose<Request, AdjustmentRequestData>
    typealias ComponentRequest = Compose<Request, ComponentRequestData>
    typealias ColorRequest = Compose<Request, ColorRequestData>
    typealias EffectRequest = Compose<Request, EffectRequestData>
    typealias ClearRequest = Compose<Request, ClearRequestData>

    // MARK: - Response

    enum ResponseType: String, Decodable {
        case serverInfo = "serverinfo"
        case instanceUpdate = "instance-update"
        case adjustmentUpdate = "adjustment-update"
        case componentUpdate = "components-update"
        case adjustmentResponse = "adjustment"
        case component = "componentstate"
        case instanceSwitch = "instance-switchTo"
        case instanceStop = "instance-stopInstance"
        case instanceStart = "instance-startInstance"
        case unknown

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let command = try container.decode(String.self)
            self = ResponseType(rawValue: command) ?? .unknown
        }
    }

    enum Response: Decodable {
        case serverInfo(ResponseServerInfo)
        case instanceUpdate(ResponseInstanceUpdate)
        case adjustmentUpdate(ResponseAdjustmentUpdate)
        case adjustmentResponse(ResponseSucess)
        case componentUpdate(ResponseComponentUpdate)
        case instanceSwitch(ResponseInstanceSwitch)
        case instanceStop(ResponseSucess)
        case instanceStart(ResponseSucess)
        case component(ResponseSucess)
        case unknown

        enum CodingKeys: String, CodingKey {
            case command
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            guard
                let command = try? container.decode(ResponseType.self, forKey: .command) else {
                    self = .unknown
                    return
            }
            let data = try decoder.singleValueContainer()
            switch command {
            case .serverInfo:
                let update = try data.decode(ResponseServerInfo.self)
                self = .serverInfo(update)
            case .instanceUpdate:
                let update = try data.decode(ResponseInstanceUpdate.self)
                self = .instanceUpdate(update)
            case .adjustmentUpdate:
                let update = try data.decode(ResponseAdjustmentUpdate.self)
                self = .adjustmentUpdate(update)
            case .componentUpdate:
                let update = try data.decode(ResponseComponentUpdate.self)
                self = .componentUpdate(update)
            case .instanceSwitch:
                let update = try data.decode(ResponseInstanceSwitch.self)
                self = .instanceSwitch(update)
            case .adjustmentResponse, .instanceStart, .instanceStop, .component:
                let update = try data.decode(ResponseSucess.self)
                self = .adjustmentResponse(update)
            case .unknown:
                self = .unknown
            }
        }
    }

    struct ResponseServerInfo: Decodable {
        var info: InfoData
    }

    struct ResponseInstanceUpdate: Decodable {
        var data: [Instance]
    }

    struct ResponseInstanceSwitch: Decodable {
        var info: ResponseInstanceInfo
        var success: Bool
    }

    struct ResponseAdjustmentUpdate: Decodable {
        var data: [Adjustment]
    }

    struct ResponseComponentUpdate: Decodable {
        var data: Component
    }

    struct ResponseSucess: Decodable {
        var success: Bool
    }

    struct ResponseInstanceInfo: Decodable {
        var instance: Int
    }

    struct InfoData: Equatable, Decodable {
        var adjustments: [Adjustment]
        var instances: [Instance]
        var hostname: String
        var effects: [Effect]
        var components: [Component]

        enum CodingKeys: String, CodingKey {
            case adjustments = "adjustment"
            case instances = "instance"
            case hostname = "hostname"
            case effects = "effects"
            case components = "components"
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

    struct Effect: Equatable, Codable, Hashable {
        var name: String
    }

    struct Component: Equatable, Decodable {
        var name: ComponentType
        var enabled: Bool
    }
}
