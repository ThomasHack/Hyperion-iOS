//
//  RequestType.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public enum RequestType: String, Codable {
    case instance = "instance"
    case serverinfo = "serverinfo"
    case adjustment = "adjustment"
    case component = "componentstate"
    case color = "color"
    case effect = "effect"
    case clear = "clear"
    case hdr = "videomodehdr"
}
