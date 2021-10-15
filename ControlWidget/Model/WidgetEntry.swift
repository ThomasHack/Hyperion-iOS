//
//  WidgetEntry.swift
//  Hyperion
//
//  Created by Hack, Thomas on 16.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation
import HyperionApi
import WidgetKit

struct WidgetEntry: TimelineEntry {
    let date: Date
    let info: HyperionApi.InfoData
    let configuration: ConfigurationIntent

    var smoothingComponent: HyperionApi.Component? {
        info.components.first(where: { $0.name == HyperionApi.ComponentType.smoothing })
    }
    var blackborderComponent: HyperionApi.Component? {
        info.components.first(where: { $0.name == HyperionApi.ComponentType.blackborder })
    }

    var ledComponent: HyperionApi.Component? {
        info.components.first(where: { $0.name == HyperionApi.ComponentType.led })
    }

    var v4lComponent: HyperionApi.Component? {
        info.components.first(where: { $0.name == HyperionApi.ComponentType.v4l })
    }

    var hdrToneMapping: HyperionApi.Component? {
        HyperionApi.Component(name: .videomodehdr, enabled: info.hdrToneMapping != 0)
    }

    var smallComponents: [HyperionApi.Component?] {
        [hdrToneMapping, smoothingComponent, blackborderComponent, ledComponent]
    }

    var mediumComponents: [HyperionApi.Component?] {
        [hdrToneMapping, smoothingComponent, blackborderComponent, ledComponent]
    }

    var largeComponents: [HyperionApi.Component?] {
        [hdrToneMapping, smoothingComponent, blackborderComponent, v4lComponent, ledComponent]
    }

    var instances: [HyperionApi.Instance] {
        info.instances
    }
}
