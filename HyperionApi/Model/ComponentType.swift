//
//  ComponentType.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public enum ComponentType: String, Equatable, Codable {
    case all = "ALL"
    case smoothing = "SMOOTHING"
    case blackborder = "BLACKBORDER"
    case forwarder = "FORWARDER"
    case boblight = "BOBLIGHTSERVER"
    case videograbber = "VIDEOGRABBER"
    case systemgrabber = "SYSTEMGRABBER"
    case v4l = "V4L"
    case led = "LEDDEVICE"
    case color = "COLOR"
    case videomodehdr = "HDR"
}
