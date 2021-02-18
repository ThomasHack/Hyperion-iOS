//
//  Main.swift
//  Hyperion
//
//  Created by Hack, Thomas on 27.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import HyperionApi

enum ConnectivityState {
    case connected
    case connecting
    case disconnected
}

enum Main {
    struct State: Equatable {

        var urlContexts: Set<UIOpenURLContext>?

        var api: Api.State
        var shared: Shared.State
        var home: Home.State
        var settings: Settings.State
        var control: Control.State

        var homeFeature: Home.HomeFeatureState {
            get { Home.HomeFeatureState(home: self.home, settings: self.settings, shared: self.shared, api: self.api) }
            set { self.home = newValue.home; self.shared = newValue.shared; self.api = newValue.api }
        }

        var settingsFeature: Settings.SettingsFeatureState {
            get { Settings.SettingsFeatureState(settings: self.settings, shared: self.shared, api: self.api) }
            set { self.settings = newValue.settings; self.shared = newValue.shared }
        }

        var controlFeature: Control.ControlFeatureState {
            get { Control.ControlFeatureState(control: self.control, api: self.api) }
            set { self.control = newValue.control; self.api = newValue.api }
        }
    }

    enum Action {
        case openURLContexts(Set<UIOpenURLContext>)
        case processURLContext(Set<UIOpenURLContext>)

        case api(Api.Action)
        case home(Home.Action)
        case shared(Shared.Action)
        case settings(Settings.Action)
        case control(Control.Action)
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let apiClient: ApiClient
        let defaults: UserDefaults
    }

    static let reducer = Reducer<State, Action, Environment>.combine(
        Reducer { state, action, environment in
            switch action {
            case .api(.didConnect):
                if let urlContexts = state.urlContexts {
                    return Effect(value: Action.processURLContext(urlContexts))
                }
                return .none
            case .openURLContexts(let URLContexts):
                if state.api.connectivityState == .connected {
                    return Effect(value: Action.processURLContext(URLContexts))
                } else {
                    state.urlContexts = URLContexts
                    return .none
                }
            case .processURLContext(let URLContexts):
                guard let context = URLContexts.first,
                  let module = context.url.host,
                  let toggle = context.url.query,
                  let enable = Bool(toggle) else { return .none }

                state.urlContexts = nil

                switch HyperionApi.ComponentType(rawValue: module) {
                case .blackborder:
                    return Effect(value: Action.api(enable ? .turnOnBlackborderDetection : .turnOffBlackborderDetection))
                case .led:
                    return Effect(value: Action.api(enable ? .turnOnLedHardware : .turnOffLedHardware))
                case .smoothing:
                    return Effect(value: Action.api(enable ? .turnOnSmoothing : .turnOffSmoothing))
                case .v4l:
                    return Effect(value: Action.api(enable ? .turnOnSmoothing : .turnOffSmoothing))
                case .videomodehdr:
                    return Effect(value: Action.api(enable ? .turnOnHdrToneMapping : .turnOffHdrToneMapping))
                default:
                    return .none
                }
            case .api, .shared, .home, .settings, .control:
                return .none
            }
        },
        Api.reducer.pullback(
            state: \State.api,
            action: /Action.api,
            environment: { $0 }
        ),
        Shared.reducer.pullback(
            state: \State.shared,
            action: /Action.shared,
            environment: { $0 }
        ),
        Home.reducer.pullback(
            state: \State.homeFeature,
            action: /Action.home,
            environment: { $0 }
        ),
        Settings.reducer.pullback(
            state: \State.settingsFeature,
            action: /Action.settings,
            environment: { $0 }
        ),
        Control.reducer.pullback(
            state: \State.controlFeature,
            action: /Action.control,
            environment: { $0 }
        )
    )
    // .debug()

    static let store = Store(
        initialState: State(
            api: Api.initialState,
            shared: Shared.initialState,
            home: Home.initialState,
            settings: Settings.initialState,
            control: Control.initialState
        ),
        reducer: reducer,
        environment: initialEnvironment
    )

    static let previewStoreHome = Store(
        initialState: Home.previewState,
        reducer: Home.reducer,
        environment: Main.Environment(
            mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
            apiClient: ApiClient.live,
            defaults: UserDefaults.standard
        )
    )

    static let previewStoreSettings = Store(
        initialState: Settings.previewState,
        reducer: Settings.reducer,
        environment: Main.Environment(
            mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
            apiClient: ApiClient.live,
            defaults: UserDefaults.standard
        )
    )

    static let previewStoreControl = Store(
        initialState: Control.previewState,
        reducer: Control.reducer,
        environment: Main.Environment(
            mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
            apiClient: ApiClient.live,
            defaults: UserDefaults.standard
        )
    )

    static let initialEnvironment = Environment(
        mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
        apiClient: ApiClient.live,
        defaults: UserDefaults.standard
    )
}

extension Store where State == Main.State, Action == Main.Action {
    var home: Store<Home.HomeFeatureState, Home.Action> {
        scope(state: \.homeFeature, action: Main.Action.home)
    }

    var settings: Store<Settings.SettingsFeatureState, Settings.Action> {
        scope(state: \.settingsFeature, action: Main.Action.settings)
    }

    var control: Store<Control.ControlFeatureState, Control.Action> {
        scope(state: \.controlFeature, action: Main.Action.control)
    }
}
