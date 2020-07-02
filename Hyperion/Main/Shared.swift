//
//  Shared.swift
//  Hyperion
//
//  Created by Hack, Thomas on 28.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import Foundation

enum Shared {
    struct State: Equatable {
        var host: String? {
            didSet {
                UserDefaults.standard.setValue(host, forKey: Shared.hostDefaultsKeyName)
            }
        }
        var showSettingsModal: Bool = false
    }

    static let hostDefaultsKeyName = "hyperion.hostname"

    static let initialState = State(
        host: UserDefaults.standard.string(forKey: hostDefaultsKeyName)
    )

    enum Action {
        case updateHost(String)
        case showSettingsModal
        case hideSettingsModal
        case toggleSettingsModal(Bool)
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .updateHost(let string):
            state.host = string
        case .showSettingsModal:
            state.showSettingsModal = true
        case .hideSettingsModal:
            state.showSettingsModal = false
        case .toggleSettingsModal(let toggle):
            state.showSettingsModal = toggle
        }
        return .none
    }
    // .debug()
}
