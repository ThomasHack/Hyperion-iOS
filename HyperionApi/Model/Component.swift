//
//  Component.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public struct Component: Equatable, Decodable, Hashable {
    public let name: ComponentType
    public let enabled: Bool

    public var label: String {
        switch name {
        case .blackborder:
            return "Blackbar Detection"
        case .boblight:
            return "Boblight Server"
        case .color:
            return "Color"
        case .forwarder:
            return "Forwarder"
        case .grabber:
            return "Internal Grabber"
        case .led:
            return "LED Hardware"
        case .smoothing:
            return "Motion Smoothing"
        case .v4l:
            return "External Grabber"
        case .all:
            return ""
        case .videomodehdr:
            return "HDR Tone Mapping"
        }
    }

    public var image: String {
        switch name {
        case .blackborder:
            return "blackborder"
        case .boblight:
            return "boblight"
        case .color:
            return "color"
        case .forwarder:
            return "forwarder"
        case .grabber:
            return "grabber"
        case .led:
            return "led-hardware"
        case .smoothing:
            return "smoothing"
        case .v4l:
            return "v4l-hardware"
        case .all:
            return ""
        case .videomodehdr:
            return "hdr-tone-mapping"
        }
    }

    public init(name: ComponentType, enabled: Bool) {
        self.name = name
        self.enabled = enabled
    }
}
