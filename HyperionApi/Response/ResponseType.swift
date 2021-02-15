//
//  ResponseType.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public enum ResponseType: String, Decodable {
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

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let command = try container.decode(String.self)
        self = ResponseType(rawValue: command) ?? .unknown
    }
}
