//
//  Main.swift
//  Hyperion
//
//  Created by Hack, Thomas on 27.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import HyperionApi
import SwiftUI

enum Main {

    enum URLContextType: String, Equatable, Codable {
        case component
        case instance
    }

    struct State: Equatable {

        var urlContexts: Set<UIOpenURLContext>?

        var api: Api.State
        var shared: Shared.State
        var home: Home.State
        var settings: Settings.State

        var homeFeature: Home.HomeFeatureState {
            get { Home.HomeFeatureState(home: self.home, settings: self.settings, shared: self.shared, api: self.api) }
            set { self.home = newValue.home; self.shared = newValue.shared; self.api = newValue.api }
        }

        var settingsFeature: Settings.SettingsFeatureState {
            get { Settings.SettingsFeatureState(settings: self.settings, shared: self.shared, api: self.api) }
            set { self.settings = newValue.settings; self.shared = newValue.shared }
        }
    }

    enum Action {
        case openURLContexts(Set<UIOpenURLContext>)
        case processURLContext(Set<UIOpenURLContext>)
        case processComponentURLContext(Set<UIOpenURLContext>)
        case processInstanceURLContext(Set<UIOpenURLContext>)

        case api(Api.Action)
        case home(Home.Action)
        case shared(Shared.Action)
        case settings(Settings.Action)
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let apiClient: ApiClient
        let defaults: UserDefaults
    }

    static let reducer = Reducer<State, Action, Environment>.combine(
        Reducer { state, action, _ in
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
                      let host = context.url.host else { return .none }

                let contextType = context.url.pathComponents[1]

                switch URLContextType(rawValue: contextType) {
                case .component:
                    return Effect(value: Action.processComponentURLContext(URLContexts))
                case .instance:
                    return Effect(value: Action.processInstanceURLContext(URLContexts))
                case .none:
                    return .none
                }
            case .processComponentURLContext(let URLContexts):
                guard let context = URLContexts.first,
                      let enable = Bool(context.url.pathComponents[3]) else { return .none }

                let componentType = context.url.pathComponents[2]

                state.urlContexts = nil

                switch HyperionApi.ComponentType(rawValue: componentType) {
                case .blackborder:
                    return Effect(value: Action.api(.toggleBlackborderDetection(enable)))
                case .led:
                    return Effect(value: Action.api(.toggleLedHardware(enable)))
                case .smoothing:
                    return Effect(value: Action.api(.toggleSmoothing(enable)))
                case .v4l:
                    return Effect(value: Action.api(.toggleHdmiGrabber(enable)))
                case .videomodehdr:
                    return Effect(value: Action.api(.toggleHdrToneMapping(enable)))
                default:
                    return .none
                }
            case .processInstanceURLContext(let URLContexts):
                guard let context = URLContexts.first,
                      let instanceId = Int(context.url.pathComponents[2]),
                      let enable = Bool(context.url.pathComponents[3]) else { return .none }

                return Effect(value: Action.api(.updateInstance(instanceId, enable)))
            case .api, .shared, .home, .settings:
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
        )
    )
    // .debug()

    static let store = Store(
        initialState: State(
            api: Api.initialState,
            shared: Shared.initialState,
            home: Home.initialState,
            settings: Settings.initialState
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

    static let previewStoreInstanceEdit = Store(
        initialState: InstanceEdit.initialState,
        reducer: InstanceEdit.reducer,
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
}
