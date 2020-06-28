//
//  Main.swift
//  Hyperion
//
//  Created by Hack, Thomas on 27.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import Foundation

enum ConnectivityState {
    case connected
    case connecting
    case disconnected
}

enum Main {
    struct State: Equatable {
        var host: String?

        var homeState: Home.State
        var settingsState: Settings.State
    }

    enum Action {
        case homeAction(Home.Action)
        case settingsAction(Settings.Action)
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let apiClient: ApiClient
        let defaults: UserDefaults
    }

    static let reducer = Reducer<State, Action, Environment>.combine(
        Reducer<State, Action, Environment> { state, action, environment in
            switch action {
            case .settingsAction(.closeSettingsModal):
                state.homeState.showSettingsModal = false
            case .homeAction(.settingsButtonTapped):
                state.settingsState.showSettingsModal = true
            case .settingsAction(.saveHostButtonTapped):
                state.host = state.settingsState.host
            case .homeAction, .settingsAction:
                return .none
            }
            return .none
        },
        Home.reducer.pullback(
            state: \State.homeState,
            action: /Action.homeAction,
            environment: { $0 }
        ),
        Settings.reducer.pullback(
            state: \State.settingsState,
            action: /Action.settingsAction,
            environment: { $0 }
        )
    ).debug()

    static let initialStore = Store(
        initialState: State(
            host: UserDefaults.standard.string(forKey: hostDefaultsKeyName),
            homeState: Home.initialState,
            settingsState: Settings.initialState
        ),
        reducer: reducer,
        environment: initialEnvironment
    )

    static let initialEnvironment = Environment(
        mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
        apiClient: .live,
        defaults: UserDefaults.standard
    )

    static let hostDefaultsKeyName = "hostname"
}

extension Store where State == Main.State, Action == Main.Action {
    var homeStore: Store<Home.State, Home.Action> {
        scope(state: \.homeState, action: Action.homeAction)
    }

    var settingsStore: Store<Settings.State, Settings.Action> {
        scope(state: \.settingsState, action: Action.settingsAction)
    }
}
