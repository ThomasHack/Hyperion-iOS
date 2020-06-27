//
//  Settings.swift
//  Hyperion
//
//  Created by Hack, Thomas on 27.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import Foundation

enum Settings {
    struct State: Equatable {
        var hostnameInput: String = ""
    }

    enum Action {
        case hostInputTextChanged(String)
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .hostInputTextChanged(let text):
            print("text: \(text)")
        }
        return .none
    }

    static let initialState = State(
        hostnameInput: "hostname.local"
    )
}
