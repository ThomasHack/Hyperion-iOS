//
//  Main.swift
//  Hyperion
//
//  Created by Hack, Thomas on 27.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import Foundation

enum Main {
    struct State: Equatable {
        var homeState: Home.State
        var settingsState: Settings.State
    }

    enum Action {
        case homeAction(Home.Action)
        case settingsAction(Settings.Action)
    }

    struct Environment {
        var mainQueue: AnySchedulerOf<DispatchQueue>
        var apiClient: ApiClient
    }

    static let reducer = Reducer<State, Action, Environment>.combine(
        Reducer<State, Action, Environment> { _, _, _ in
            .none
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
    )

    static let initialStore = Store(
        initialState: State(
            homeState: Home.initialState,
            settingsState: Settings.initialState
        ),
        reducer: reducer,
        environment: initialEnvironment
    )

    static let initialEnvironment = Environment(
        mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
        apiClient: .live
    )
}

extension Store where State == Main.State, Action == Main.Action {
    var homeStore: Store<Home.State, Home.Action> {
        scope(state: \.homeState, action: Action.homeAction)
    }

    var settingsStore: Store<Settings.State, Settings.Action> {
        scope(state: \.settingsState, action: Action.settingsAction)
    }
}
