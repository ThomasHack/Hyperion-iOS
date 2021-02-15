//
//  InfoData.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public struct InfoData: Equatable, Decodable {
    public let adjustments: [Adjustment]
    public let instances: [Instance]
    public let hostname: String
    public let effects: [LightEffect]
    public let components: [Component]
    public let priorities: [Priority]
    public let hdrToneMapping: Int

    enum CodingKeys: String, CodingKey {
        case adjustments = "adjustment"
        case instances = "instance"
        case hostname = "hostname"
        case effects = "effects"
        case components = "components"
        case priorities = "priorities"
        case hdrToneMapping = "videomodehdr"
    }

    public init(adjustments: [Adjustment], instances: [Instance], hostname: String, effects: [LightEffect], components: [Component], priorities: [Priority], hdrToneMapping: Int) {
        self.adjustments = adjustments
        self.instances = instances
        self.hostname = hostname
        self.effects = effects
        self.components = components
        self.priorities = priorities
        self.hdrToneMapping = hdrToneMapping
    }
}
