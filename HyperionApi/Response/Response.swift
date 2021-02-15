//
//  Response.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public enum Response: Decodable {
    case serverInfo(ServerInfoUpdate)
    case instanceUpdate(InstanceUpdate)
    case adjustmentUpdate(AdjustmentUpdate)
    case adjustmentResponse(Sucess)
    case priorityUpdate(PriorityUpdate)
    case componentUpdate(ComponentUpdate)
    case hdrToneMappingUpdate(HdrToneMappingUpdate)
    case instanceSwitch(InstanceSwitchUpdate)
    case instanceStop(Sucess)
    case instanceStart(Sucess)
    case component(Sucess)
    case hdrToneMapping(Sucess)
    case unknown

    enum CodingKeys: String, CodingKey {
        case command
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard
            let command = try? container.decode(ResponseType.self, forKey: .command) else {
                self = .unknown
                return
        }
        let data = try decoder.singleValueContainer()
        switch command {
        case .serverInfo:
            let update = try data.decode(ServerInfoUpdate.self)
            self = .serverInfo(update)
        case .instanceUpdate:
            let update = try data.decode(InstanceUpdate.self)
            self = .instanceUpdate(update)
        case .adjustmentUpdate:
            let update = try data.decode(AdjustmentUpdate.self)
            self = .adjustmentUpdate(update)
        case .priorityUpdate:
            let update = try data.decode(PriorityUpdate.self)
            self = .priorityUpdate(update)
        case .componentUpdate:
            let update = try data.decode(ComponentUpdate.self)
            self = .componentUpdate(update)
        case .hdrToneMappingUpdate:
            let update = try data.decode(HdrToneMappingUpdate.self)
            self = .hdrToneMappingUpdate(update)
        case .instanceSwitch:
            let update = try data.decode(InstanceSwitchUpdate.self)
            self = .instanceSwitch(update)
        case .adjustmentResponse, .instanceStart, .instanceStop, .component, .hdrToneMapping:
            let update = try data.decode(Sucess.self)
            self = .adjustmentResponse(update)
        case .unknown:
            self = .unknown
        }
    }
}
