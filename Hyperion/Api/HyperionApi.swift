//
//  HyperionApi.swift
//  Hyperion
//
//  Created by Hack, Thomas on 26.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import UIKit

// MARK: - Request

enum HyperionApi {

    struct Request: Equatable, Codable {
        let command: RequestCommandType
    }

    enum RequestCommandType: String, Codable {
        case instance = "instance"
        case serverinfo = "serverinfo"
        case adjustment = "adjustment"
        case component = "componentstate"
        case color = "color"
        case effect = "effect"
        case clear = "clear"
        case hdr = "videomodehdr"
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
        case priorityUpdate = "priorities-update"
        case videoModeHdrUpdate = "videomodehdr-update"
    }

    struct InstanceRequestData: Equatable, Codable {
        let subcommand: RequestSubCommandType
        let instance: Int
    }

    struct SubscribeRequestData: Equatable, Codable {
        let subscribe: [SubscribeType]
    }

    struct AdjustmentRequestData: Equatable, Codable {
        let adjustment: Adjustment
    }

    struct ComponentRequestData: Equatable, Codable {
        let componentstate: ComponentState
    }

    struct ColorRequestData: Equatable, Codable {
        let color: [Int]
        let priority: Int
        let origin: String
    }

    struct EffectRequestData: Equatable, Codable {
        let effect: Effect
        let priority: Int
        let origin: String
    }

    struct ClearRequestData: Equatable, Codable {
        let priority: Int
    }

    struct HdrToneMappingRequestData: Equatable, Codable {
        let hdr: Int

        enum CodingKeys: String, CodingKey {
            case hdr = "HDR"
        }
    }

    struct ComponentState: Equatable, Codable {
        let component: ComponentType
        let state: Bool
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
        case color = "COLOR"
    }

    typealias InstanceRequest = Compose<Request, InstanceRequestData>
    typealias SubscribeRequest = Compose<Request, SubscribeRequestData>
    typealias AdjustmentRequest = Compose<Request, AdjustmentRequestData>
    typealias ComponentRequest = Compose<Request, ComponentRequestData>
    typealias ColorRequest = Compose<Request, ColorRequestData>
    typealias EffectRequest = Compose<Request, EffectRequestData>
    typealias ClearRequest = Compose<Request, ClearRequestData>
    typealias HdrToneMappingRequest = Compose<Request, HdrToneMappingRequestData>

    // MARK: - Response

    enum ResponseType: String, Decodable {
        case serverInfo = "serverinfo"
        case instanceUpdate = "instance-update"
        case adjustmentUpdate = "adjustment-update"
        case componentUpdate = "components-update"
        case hdrToneMappingUpdate = "videomodehdr-update"
        case adjustmentResponse = "adjustment"
        case priorityUpdate = "priorities-update"
        case component = "componentstate"
        case instanceSwitch = "instance-switchTo"
        case instanceStop = "instance-stopInstance"
        case instanceStart = "instance-startInstance"
        case hdrToneMapping = "videomodehdr"
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
        case priorityUpdate(ResponsePriorityUpdate)
        case componentUpdate(ResponseComponentUpdate)
        case hdrToneMappingUpdate(ResponseHdrToneMappingUpdate)
        case instanceSwitch(ResponseInstanceSwitch)
        case instanceStop(ResponseSucess)
        case instanceStart(ResponseSucess)
        case component(ResponseSucess)
        case hdrToneMapping(ResponseSucess)
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
            case .priorityUpdate:
                let update = try data.decode(ResponsePriorityUpdate.self)
                self = .priorityUpdate(update)
            case .componentUpdate:
                let update = try data.decode(ResponseComponentUpdate.self)
                self = .componentUpdate(update)
            case .hdrToneMappingUpdate:
                let update = try data.decode(ResponseHdrToneMappingUpdate.self)
                self = .hdrToneMappingUpdate(update)
            case .instanceSwitch:
                let update = try data.decode(ResponseInstanceSwitch.self)
                self = .instanceSwitch(update)
            case .adjustmentResponse, .instanceStart, .instanceStop, .component, .hdrToneMapping:
                let update = try data.decode(ResponseSucess.self)
                self = .adjustmentResponse(update)
            case .unknown:
                self = .unknown
            }
        }
    }

    struct ResponseServerInfo: Decodable {
        let info: InfoData
    }

    struct ResponseInstanceUpdate: Decodable {
        let data: [Instance]
    }

    struct ResponseInstanceSwitch: Decodable {
        let info: ResponseInstanceInfo
        let success: Bool
    }

    struct ResponseAdjustmentUpdate: Decodable {
        let data: [Adjustment]
    }

    struct ResponseComponentUpdate: Decodable {
        let data: Component
    }

    struct ResponseHdrToneMappingUpdate: Decodable {
        let data: HdrToneMappingData
    }

    struct ResponsePriorityUpdate: Decodable {
        let data: PrioritiesData
    }

    struct ResponseSucess: Decodable {
        let success: Bool
    }

    struct ResponseInstanceInfo: Decodable {
        let instance: Int
    }

    struct PrioritiesData: Equatable, Decodable {
        let priorities: [Priority]
        let priorities_autoselect: Bool
    }

    struct HdrToneMappingData: Equatable, Decodable {
        let videomodehdr: Int
    }

    struct InfoData: Equatable, Decodable {
        let adjustments: [Adjustment]
        let instances: [Instance]
        let hostname: String
        let effects: [Effect]
        let components: [Component]
        let priorities: [Priority]
        let hdrToneMapping: Int

        enum CodingKeys: String, CodingKey {
            case adjustments = "adjustment"
            case instances = "instance"
            case hostname = "hostname"
            case effects = "effects"
            case components = "components"
            case priorities = "priorities"
            case hdrToneMapping = "videomodehdr"
        }
    }

    struct Adjustment: Equatable, Codable {
        let brightness: Int
    }

    struct Instance: Equatable, Decodable, Hashable {
        let instance: Int
        let running: Bool
        let friendlyName: String

        enum CodingKeys: String, CodingKey {
            case instance = "instance"
            case running = "running"
            case friendlyName = "friendly_name"
        }
    }

    struct Effect: Equatable, Codable, Hashable {
        let name: String
    }

    struct Component: Equatable, Decodable {
        let name: ComponentType
        let enabled: Bool
    }

    struct Priority: Equatable, Decodable {
        let active: Bool
        let componentId: ComponentType
        let origin: String
        let priority: Int
        let visible: Bool
        let value: PriorityValue?
    }

    struct PriorityValue: Equatable, Decodable {
        let hsl: [Float]
        let rgb: [Float]

        var color: UIColor? {
            get {
                guard rgb.count == 3 else { return nil }
                return UIColor(red: CGFloat(rgb[0]/255), green: CGFloat(rgb[1]/255), blue: CGFloat(rgb[2]/255), alpha: 1.0)
            }
        }

        enum CodingKeys: String, CodingKey {
            case hsl = "HSL"
            case rgb = "RGB"
        }
    }
}
