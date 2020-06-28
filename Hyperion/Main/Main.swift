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
        var showSettingsModal: Bool = false
        
        var sharedState: Shared.State
        var homeState: Home.State
        var settingsState: Settings.State
    }

    enum Action {
        case updateHost(String)
        case toggleSettingsModal

        case sharedAction(Shared.Action)
        case homeAction(Home.Action)
        case settingsAction(Settings.Action)
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let apiClient: ApiClient
        let defaults: UserDefaults
    }

    static let reducer = Reducer<State, Action, Environment>.combine(
        Reducer<State, Action, Environment> { state, action, _ in
            switch action {
            case .updateHost(let string):
                state.host = string
            case .toggleSettingsModal:
                print("toggle")
                state.showSettingsModal.toggle()
            case .homeAction(.toggleSettingsModal), .settingsAction(.toggleSettingsModal):
                state.homeState.showSettingsModal.toggle()
                // state.settingsState.showSettingsModal.toggle()
            case .sharedAction, .homeAction, .settingsAction:
                return.none
            }
            return .none
        },
        Shared.reducer.pullback(
            state: \State.sharedState,
            action: /Action.sharedAction,
            environment: { $0 }
        ),
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
    .debug()

    static let initialStore = Store(
        initialState: State(
            sharedState: Shared.initialState,
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
}

extension Store where State == Main.State, Action == Main.Action {
    var sharedStore: Store<Shared.State, Shared.Action> {
        scope(state: \.sharedState, action: Action.sharedAction)
    }

    var homeStore: Store<Home.State, Home.Action> {
        scope(state: \.homeState, action: Action.homeAction)
    }

    var settingsStore: Store<Settings.State, Settings.Action> {
        scope(state: \.settingsState, action: Action.settingsAction)
    }
}
