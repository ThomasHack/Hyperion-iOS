//
//  Api.swift
//  Hyperion
//
//  Created by Hack, Thomas on 26.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import UIKit
import SwiftUI
import ComposableArchitecture
import Combine
import Starscream
import HyperionApi

struct ApiId: Hashable {}

enum Api {
    struct State: Equatable {
        var connectivityState: ConnectivityState = .disconnected
        var hostname: String = ""
        var instances: [HyperionApi.Instance] = []
        var effects: [HyperionApi.LightEffect] = []
        var components: [HyperionApi.Component] = []
        var priorities: [HyperionApi.Priority] = []
        var hdrToneMapping: Bool = false

        var smoothingComponent: HyperionApi.Component? {
            components.first(where: { $0.name == HyperionApi.ComponentType.smoothing })
        }
        var blackborderComponent: HyperionApi.Component? {
            components.first(where: { $0.name == HyperionApi.ComponentType.blackborder})
        }

        var ledComponent: HyperionApi.Component? {
            components.first(where: { $0.name == HyperionApi.ComponentType.led})
        }

        var v4lComponent: HyperionApi.Component? {
            components.first(where: { $0.name == HyperionApi.ComponentType.v4l})
        }

        var smoothingEnabled: Bool {
            smoothingComponent?.enabled ?? false
        }
        var blackborderDetectionEnabled: Bool {
            blackborderComponent?.enabled ?? false
        }

        var highestPriority: HyperionApi.Priority? {
            priorities.sorted(by: { $0.priority < $1.priority}).first
        }

        var currentColor: Color {
            guard let priority = highestPriority?.value, let color = priority.color else {
                return Color.clear
            }
            return Color(color)
        }

        var priorityShutdown: Bool {
            guard let priority = highestPriority, let color = priority.value?.color else { return false }
            return priority.componentId == HyperionApi.ComponentType.color && color.isEqual(UIColor(red: 0, green: 0, blue: 0, alpha: 1.0))
        }

        var brightness: Double = 0
        var selectedInstance: Int = 0
    }

    enum Action: Equatable {
        case connect(URL)
        case disconnect
        case subscribe
        case selectInstance(Int)
        case updateInstance(Int, Bool)
        case updateBrightness(Double)
        case updateColor(HyperionApi.RGB)
        case updateEffect(HyperionApi.LightEffect)
        case turnOnSmoothing
        case turnOffSmoothing
        case turnOnBlackborderDetection
        case turnOffBlackborderDetection
        case turnOnLedHardware
        case turnOffLedHardware
        case turnOnHdmiGrabber
        case turnOffHdmiGrabber
        case turnOnHdrToneMapping
        case turnOffHdrToneMapping
        case clear

        case didConnect
        case didDisconnect
        case didSubscribe
        case didReceiveWebSocketEvent(HyperionApi.ApiEvent)
        case didUpdateBrightness(Double)
        case didUpdateInstances([HyperionApi.Instance])
        case didUpdateEffects([HyperionApi.LightEffect])
        case didUpdateComponent(HyperionApi.Component)
        case didUpdateComponents([HyperionApi.Component])
        case didUpdateHostname(String)
        case didUpdateSelectedInstance(Int)
        case didUpdatePriorities([HyperionApi.Priority])
        case didUpdateHdrToneMapping(Bool)
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .connect(let url):
            return environment.apiClient.connect(ApiId(), url)
                .receive(on: environment.mainQueue)
                .eraseToEffect()

        case .disconnect:
            return environment.apiClient.disconnect(ApiId())
                .receive(on: environment.mainQueue)
                .eraseToEffect()

        case .subscribe:
            return environment.apiClient.subscribe(ApiId())
                .receive(on: environment.mainQueue)
                .eraseToEffect()

        case .selectInstance(let instanceId):
            return environment.apiClient.selectInstance(ApiId(), instanceId)
                .receive(on: environment.mainQueue)
                .eraseToEffect()

        case .updateInstance(let instanceId, let running):
            return environment.apiClient.updateInstance(ApiId(), instanceId, !running)
                .receive(on: environment.mainQueue)
                .eraseToEffect()

        case .updateBrightness(let brightness):
            return environment.apiClient.updateBrightness(ApiId(), brightness)
                .receive(on: environment.mainQueue)
                .eraseToEffect()

        case .updateColor(let color):
            return environment.apiClient.updateColor(ApiId(), color)
                .receive(on: environment.mainQueue)
                .eraseToEffect()

        case .updateEffect(let effect):
            return environment.apiClient.updateEffect(ApiId(), effect)
                .receive(on: environment.mainQueue)
                .eraseToEffect()

        case .turnOnSmoothing:
            return environment.apiClient.toggleSmoothing(ApiId(), true)
                .receive(on: environment.mainQueue)
                .eraseToEffect()

        case .turnOffSmoothing:
            return environment.apiClient.toggleSmoothing(ApiId(), false)
                .receive(on: environment.mainQueue)
                .eraseToEffect()

        case .turnOnBlackborderDetection:
            return environment.apiClient.toggleBlackborderDetection(ApiId(), true)
                .receive(on: environment.mainQueue)
                .eraseToEffect()

        case .turnOffBlackborderDetection:
            return environment.apiClient.toggleBlackborderDetection(ApiId(), false)
                .receive(on: environment.mainQueue)
                .eraseToEffect()

        case .turnOnLedHardware:
            return environment.apiClient.toggleLedHardware(ApiId(), true)
                .receive(on: environment.mainQueue)
                .eraseToEffect()

        case .turnOffLedHardware:
            return environment.apiClient.toggleLedHardware(ApiId(), false)
                .receive(on: environment.mainQueue)
                .eraseToEffect()

        case .turnOnHdmiGrabber:
            return environment.apiClient.toggleHdmiGrabber(ApiId(), true)
                .receive(on: environment.mainQueue)
                .eraseToEffect()

        case .turnOffHdmiGrabber:
            return environment.apiClient.toggleHdmiGrabber(ApiId(), false)
                .receive(on: environment.mainQueue)
                .eraseToEffect()

        case .turnOnHdrToneMapping:
            return environment.apiClient.toggleHdrToneMapping(ApiId(), 1)
                .receive(on: environment.mainQueue)
                .eraseToEffect()

        case .turnOffHdrToneMapping:
            return environment.apiClient.toggleHdrToneMapping(ApiId(), 0)
                .receive(on: environment.mainQueue)
                .eraseToEffect()

        case .clear:
            return environment.apiClient.clear(ApiId())
                .receive(on: environment.mainQueue)
                .eraseToEffect()

        case .didConnect:
            state.connectivityState = .connected
            return environment.apiClient.subscribe(ApiId())
                .receive(on: environment.mainQueue)
                .eraseToEffect()

        case .didDisconnect:
            state.connectivityState = .disconnected
            state.hostname = ""
            state.instances = []
            state.effects = []
            state.components = []

        case .didReceiveWebSocketEvent(let event):
            print("event")

        case .didUpdateBrightness(let brightness):
            state.brightness = Double(brightness)

        case .didUpdateInstances(let instances):
            state.instances = instances
            if let instance = state.instances.first(where: { $0.instance == state.selectedInstance }), !instance.running {
                return environment.apiClient.selectInstance(ApiId(), 0)
                    .receive(on: environment.mainQueue)
                    .eraseToEffect()
            }
        case .didUpdateEffects(let effects):
            state.effects = effects

        case .didUpdateComponent(let component):
            var newValue = state.components
            if let index = newValue.firstIndex(where: { $0.name == component.name }) {
                newValue[index] = component
            }
            state.components = newValue

        case .didUpdateComponents(let components):
            state.components = components

        case .didUpdateHostname(let hostname):
            state.hostname = hostname

        case .didUpdateSelectedInstance(let selectedInstance):
            state.selectedInstance = selectedInstance
            return environment.apiClient.subscribe(ApiId())
                .receive(on: environment.mainQueue)
                .eraseToEffect()

        case .didUpdatePriorities(let priorities):
            state.priorities = priorities

        case .didUpdateHdrToneMapping(let hdrToneMapping):
            state.hdrToneMapping = hdrToneMapping

        case .didSubscribe:
            break
        }
        return .none
    }
    //.debug()

    static let initialState = State()

    static let previewState = State(
        connectivityState: .connected,
        hostname: "Preview",
        instances: [
            HyperionApi.Instance(instance: 0, running: true, friendlyName: "LG OLED Ambilight"),
            HyperionApi.Instance(instance: 1, running: false, friendlyName: "Hue Sync"),
            HyperionApi.Instance(instance: 1, running: false, friendlyName: "Hue Play Lightbars")
        ],
        effects: [
            HyperionApi.LightEffect(name: "Atomic swirl"),
            HyperionApi.LightEffect(name: "Blue mood blobs"),
            HyperionApi.LightEffect(name: "Breath"),
            HyperionApi.LightEffect(name: "Cold mood blobs"),
            HyperionApi.LightEffect(name: "Full color mood blobs"),
            HyperionApi.LightEffect(name: "Knight rider"),
            HyperionApi.LightEffect(name: "Light clock"),
            HyperionApi.LightEffect(name: "Pac-Man"),
            HyperionApi.LightEffect(name: "Police Lights Solid"),
            HyperionApi.LightEffect(name: "Sea waves"),
            HyperionApi.LightEffect(name: "Strobe red"),
            HyperionApi.LightEffect(name: "Waves with Color"),
        ],
        components: [
            HyperionApi.Component(name: .blackborder, enabled: true),
            HyperionApi.Component(name: .smoothing, enabled: true),
            HyperionApi.Component(name: .led, enabled: true),
            HyperionApi.Component(name: .v4l, enabled: true),
        ],
        hdrToneMapping: false,
        brightness: 65,
        selectedInstance: 0
    )
}
