//
//  InstanceEdit.swift
//  Hyperion
//
//  Created by Hack, Thomas on 21.06.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import HyperionApi
import Foundation

enum InstanceEdit {

    struct State: Equatable {
        var instance: HyperionApi.Instance?
        var iconName: String = ""
        var instanceName: String = ""
    }

    indirect enum Action {
        case iconNameChanged(String)
        case instanceNameChanged(String)
        case shared(Shared.Action)
        case settings(Settings.Action)
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<InstanceEditFeatureState, Action, Environment>.combine(
        Reducer { state, action, environment in
            switch action {
            case .iconNameChanged(let text):
                return Effect(value: .settings(.iconNameChanged(instance: state.instanceName, iconName: text)))
            case .instanceNameChanged(let instanceName):
                break
            case .shared, .settings:
                break
            }
            return .none
        },
        Shared.reducer.pullback(
            state: \InstanceEditFeatureState.shared,
            action: /Action.shared,
            environment: { $0 }
        )
    )

    static let initialState = State(
        instance: nil,
        iconName: "",
        instanceName: ""
    )

    // viewStore.icons?[instance.friendlyName]
}
