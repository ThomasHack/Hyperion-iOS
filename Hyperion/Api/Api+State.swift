//
//  Api+State.swift
//  Hyperion
//
//  Created by Hack, Thomas on 15.10.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import HyperionApi
import SwiftUI
import UIKit

extension Api {
    struct State: Equatable {
        var connectivityState: ConnectivityState = .disconnected
        var hostname: String = ""
        var instances: [HyperionApi.Instance] = []
        var effects: [HyperionApi.LightEffect] = []
        var components: [HyperionApi.Component] = []
        var priorities: [HyperionApi.Priority] = []
        var hdrToneMapping = false

        var connectionColor: UIColor {
            switch connectivityState {
            case .connected:
                return allEnabled ? UIColor.systemGreen : .systemOrange
            case .connecting:
                return UIColor.systemBlue
            case .disconnected:
                return UIColor.systemRed
            }
        }

        var allEnabled: Bool {
            allComponent?.enabled ?? false
        }

        var allComponent: HyperionApi.Component? {
            components.first(where: { $0.name == HyperionApi.ComponentType.all })
        }

        var smoothingComponent: HyperionApi.Component? {
            components.first(where: { $0.name == HyperionApi.ComponentType.smoothing })
        }

        var blackborderComponent: HyperionApi.Component? {
            components.first(where: { $0.name == HyperionApi.ComponentType.blackborder })
        }

        var ledComponent: HyperionApi.Component? {
            components.first(where: { $0.name == HyperionApi.ComponentType.led })
        }

        var v4lComponent: HyperionApi.Component? {
            components.first(where: { $0.name == HyperionApi.ComponentType.v4l })
        }

        var smoothingEnabled: Bool {
            smoothingComponent?.enabled ?? false
        }
        var blackborderDetectionEnabled: Bool {
            blackborderComponent?.enabled ?? false
        }

        var highestPriority: HyperionApi.Priority? {
            priorities.min(by: { $0.priority < $1.priority })
        }

        var currentColor: Color {
            guard let priority = highestPriority?.value, let color = priority.color else {
                return Color.clear
            }
            return Color(color)
        }

        var priorityShutdown: Bool {
            guard let priority = highestPriority,
                    let color = priority.value?.color else { return false }
            let priorityIsColor = priority.componentId == HyperionApi.ComponentType.color
            let colorIsEqual = color.isEqual(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1.0))

            return priorityIsColor && colorIsEqual
        }

        var brightness: Double = 0
        var selectedInstance: Int = 0
    }
}
