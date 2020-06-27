//
//  AppReducer.swift
//  Hyperion
//
//  Created by Hack, Thomas on 26.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import Foundation
import ComposableArchitecture

struct AppState: Equatable {
    var connectivityState: ConnectivityState = .disconnected
    var receivedMessages: [String] = []
    var brightness: Double = 0
    var hostname: String = ""
    var instances: [Instance] = []
    var selectedInstance: Int = 0

    enum ConnectivityState {
        case connected
        case connecting
        case disconnected
    }
}

enum AppAction {
    case connectButtonTapped
    case instanceButtonTapped(Int, Bool)
    case selectInstance(Int)
    case updateBrightness(Double)
    case apiClient(ApiClient.Action)
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    struct ApiId: Hashable {}

    switch action {
    case .connectButtonTapped:
        switch state.connectivityState {
        case .connected, .connecting:
            return environment.apiClient.disconnect(ApiId())
                .receive(on: environment.mainQueue)
                .map(AppAction.apiClient)
                .eraseToEffect()
        case .disconnected:
            return environment.apiClient.connect(ApiId(), URL(string: "ws://hyperion.home:8090/")!)
                .receive(on: environment.mainQueue)
                .map(AppAction.apiClient)
                .eraseToEffect()
        }
    case .instanceButtonTapped(let instanceId, let running):
        return environment.apiClient.updateInstance(ApiId(), instanceId, running)
            .receive(on: environment.mainQueue)
            .map(AppAction.apiClient)
            .eraseToEffect()
    case .selectInstance(let instanceId):
        return environment.apiClient.switchToInstance(ApiId(), instanceId)
            .receive(on: environment.mainQueue)
            .map(AppAction.apiClient)
            .eraseToEffect()
    case .updateBrightness(let brightness):
        return environment.apiClient.updateBrightness(ApiId(), brightness)
            .receive(on: environment.mainQueue)
            .map(AppAction.apiClient)
            .eraseToEffect()
    case .apiClient(.didConnect):
        state.connectivityState = .connected
        return environment.apiClient.subscribe(ApiId())
            .receive(on: environment.mainQueue)
            .map(AppAction.apiClient)
            .eraseToEffect()
    case .apiClient(.didDisconnect):
        state.connectivityState = .disconnected
    case .apiClient(.didReceiveWebSocketEvent(let event)):
        print("event")
    case .apiClient(.didUpdateBrightness(let brightness)):
        state.brightness = Double(brightness)
    case .apiClient(.didUpdateInstances(let instances)):
        state.instances = instances
        if let instance = instances.first(where: { $0.instance == state.selectedInstance }), !instance.running {
            return environment.apiClient.switchToInstance(ApiId(), 0)
                .receive(on: environment.mainQueue)
                .map(AppAction.apiClient)
                .eraseToEffect()
        }
    case .apiClient(.didUpdateHostname(let hostname)):
        state.hostname = hostname
    case .apiClient(.didUpdateSelectedInstance(let selectedInstance)):
        print("didUpdateSelectedInstance \(selectedInstance)")
        state.selectedInstance = selectedInstance
        return environment.apiClient.subscribe(ApiId())
            .receive(on: environment.mainQueue)
            .map(AppAction.apiClient)
            .eraseToEffect()
    }
    return .none
}
//.debug()
