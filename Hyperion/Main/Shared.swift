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
        var host: String?
        var showSettingsModal: Bool = false
    }

    enum Action {
        case updateHost(String)
        case toggleSettingsModal
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<State, Action, Environment> { state, action, _ in
        switch action {
        case .updateHost(let string):
            state.host = string
        case .toggleSettingsModal:
            print("toggle")
            state.showSettingsModal.toggle()
        }
        return .none
    }

    static let hostDefaultsKeyName = "hyperion.hostname"

    static let initialState = State(
        host: UserDefaults.standard.string(forKey: hostDefaultsKeyName),
        showSettingsModal: false
    )
}
