//
//  Settings.swift
//  Hyperion
//
//  Created by Hack, Thomas on 27.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import HyperionApi
import Network
import SwiftUI

enum Settings {
    struct State: Equatable {
        var hostInput: String = ""
        var backgroundImage: String = ""
        var selection: Identified<Int, InstanceEdit.State?>?
    }

    enum Action {
        case setSelection(Int?)

        case hostInputTextChanged(String)
        case backgroundImageChanged(String)
        case connectButtonTapped
        case doneButtonTapped
        case hideSettingsModal

        case api(Api.Action)
        case shared(Shared.Action)
        case instanceEdit(InstanceEdit.Action)
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<SettingsFeatureState, Action, Environment>.combine(
        Reducer { state, action, _ in
            switch action {
            case .setSelection(let instanceId):
                guard let instanceId = instanceId else {
                    guard let instance = state.selection?.value?.instance,
                          let instanceName = state.selection?.value?.instanceName,
                          let iconName = state.selection?.value?.iconName else {
                        state.selection = nil
                        return .none
                    }
                    state.selection = nil
                    return .merge(
                        Effect(value: .shared(.updateInstanceName(instance.id, instanceName))),
                        Effect(value: .shared(.updateIcon(instance.id, iconName)))
                    )
                }
                guard let instance = state.api.instances.first(where: { $0.id == instanceId }) else { return .none }
                let iconName = state.shared.icons[instance.id] ?? ""
                let instanceName = state.shared.instanceNames[instance.id] ?? ""
                let instanceEditState = InstanceEdit.State(
                    instance: instance,
                    iconName: iconName,
                    instanceName: instanceName
                )
                state.selection = Identified(instanceEditState, id: instanceId)
                return .none

            case .hostInputTextChanged(let text):
                state.hostInput = text

            case .backgroundImageChanged(let text):
                state.backgroundImage = text
                return Effect(value: .shared(.updateBackgroundImage(state.backgroundImage)))

            case .connectButtonTapped:
                switch state.connectivityState {
                case .connected, .connecting:
                    return Effect(value: Action.api(.disconnect))

                case .disconnected:
                    guard let url = URL(string: "ws://\(state.hostInput)") else { return .none }
                    return Effect(value: Action.api(.connect(url)))
                }

            case .hideSettingsModal:
                state.showSettingsModal = false

            case .doneButtonTapped:
                state.shared.host = state.hostInput
                return Effect(value: .hideSettingsModal)

            case .instanceEdit(.iconNameChanged(let iconName)):
                guard let uid = state.selection?.id,
                      let instance = state.api.instances.first(where: { $0.id == uid }) else { return .none }
                state.shared.icons[instance.id] = iconName
                return Effect(value: .shared(.updateIcons(state.shared.icons)))

            case .shared, .api, .instanceEdit:
                break
            }
            return .none
        },
        Shared.reducer.pullback(
            state: \SettingsFeatureState.shared,
            action: /Action.shared,
            environment: { $0 }
        ),
        Api.reducer.pullback(
            state: \SettingsFeatureState.api,
            action: /Action.api,
            environment: { $0 }
        ),
        InstanceEdit.reducer
            .optional()
            .pullback(state: \Identified.value, action: .self, environment: { $0 })
            .optional()
            .pullback(
                state: \Settings.SettingsFeatureState.selection,
                action: /Action.instanceEdit,
                environment: { $0 }
            )
    )

    static let initialState = State(
        hostInput: UserDefaults(suiteName: Shared.appGroupName)?.string(forKey: Shared.hostDefaultsKeyName) ?? "",
        backgroundImage: UserDefaults(suiteName: Shared.appGroupName)?.string(forKey: Shared.backgroundDefaultsKeyName) ?? "",
        selection: nil
    )
}
