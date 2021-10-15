//
//  InstanceEdit.swift
//  Hyperion
//
//  Created by Hack, Thomas on 21.06.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//  

import ComposableArchitecture
import Foundation
import HyperionApi

enum InstanceEdit {

    struct State: Equatable {
        var instance: HyperionApi.Instance
        var iconName: String
        var instanceName: String
    }

    enum Action {
        case iconNameChanged(String)
        case instanceNameChanged(String)
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<State, Action, Environment>.combine(
        Reducer { state, action, _ in
            switch action {
            case .iconNameChanged(let iconName):
                state.iconName = iconName
                return .none
            case .instanceNameChanged(let instanceName):
                state.instanceName = instanceName
                return .none
            }
        }
    )

    static let initialState = State(
        instance: HyperionApi.Instance(
            instance: 0,
            running: false,
            friendlyName: ""
        ),
        iconName: "",
        instanceName: ""
    )
}
