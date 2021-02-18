//
//  WidgetEntry.swift
//  Hyperion
//
//  Created by Hack, Thomas on 16.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation
import WidgetKit
import HyperionApi

struct WidgetEntry: TimelineEntry {
    let date: Date
    let info: HyperionApi.InfoData
    let configuration: ConfigurationIntent

    var smoothingComponent: Component? {
        guard let component = info.components.first(where: { $0.name == HyperionApi.ComponentType.smoothing }) else { return nil }
        return Component(name: component.name.rawValue, label: component.label, image: component.image, enabled: component.enabled)
    }
    var blackborderComponent: Component? {
        guard let component = info.components.first(where: { $0.name == HyperionApi.ComponentType.blackborder}) else { return nil }
        return Component(name: component.name.rawValue, label: component.label, image: component.image, enabled: component.enabled)
    }

    var ledComponent: Component? {
        guard let component = info.components.first(where: { $0.name == HyperionApi.ComponentType.led}) else { return nil }
        return Component(name: component.name.rawValue, label: component.label, image: component.image, enabled: component.enabled)
    }

    var v4lComponent: Component? {
        guard let component = info.components.first(where: { $0.name == HyperionApi.ComponentType.v4l}) else { return nil }
        return Component(name: component.name.rawValue, label: component.label, image: component.image, enabled: component.enabled)
    }

    var hdrToneMapping: Component? {
        return Component(name: "VIDEMODEHDR", label: "HDR Tone Mapping", image: "hdr-tone-mapping", enabled: info.hdrToneMapping != 0)
    }

    var smallComponents: [Component?] {
        return [hdrToneMapping, smoothingComponent, blackborderComponent, ledComponent]
    }

    var mediumComponents: [Component?] {
        return [hdrToneMapping, smoothingComponent, blackborderComponent, ledComponent]
    }

    var largeComponents: [Component?] {
        return [hdrToneMapping, smoothingComponent, blackborderComponent, ledComponent, v4lComponent]
    }
}
