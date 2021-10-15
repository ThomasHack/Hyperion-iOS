//
//  Api+Reducer.swift
//  Hyperion
//
//  Created by Hack, Thomas on 15.10.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import Foundation

extension Api {
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

        case let .updateInstance(instanceId, running):
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

        case .toggleAll(let enable):
            return environment.apiClient.toggleAll(ApiId(), enable)
                .receive(on: environment.mainQueue)
                .eraseToEffect()

        case .toggleSmoothing(let enable):
            return environment.apiClient.toggleSmoothing(ApiId(), enable)
                .receive(on: environment.mainQueue)
                .eraseToEffect()

        case .toggleBlackborderDetection(let enable):
            return environment.apiClient.toggleBlackborderDetection(ApiId(), enable)
                .receive(on: environment.mainQueue)
                .eraseToEffect()

        case .toggleLedHardware(let enable):
            return environment.apiClient.toggleLedHardware(ApiId(), enable)
                .receive(on: environment.mainQueue)
                .eraseToEffect()

        case .toggleHdmiGrabber(let enable):
            return environment.apiClient.toggleHdmiGrabber(ApiId(), enable)
                .receive(on: environment.mainQueue)
                .eraseToEffect()

        case .toggleHdrToneMapping(let enable):
            return environment.apiClient.toggleHdrToneMapping(ApiId(), enable ? 1 : 0)
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
            if let instance = state.instances.first(where: { $0.id == state.selectedInstance }), !instance.running {
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
}
