//
//  AppState.swift
//  Hyperion
//
//  Created by Hack, Thomas on 14.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct AppState: Equatable {
    var api: API = API()
    var instances: [Instance] = []
    var hostname: String = ""
    var brightness: Int = 0
}

enum AppAction: Equatable  {
    case connect
    case adjustBrightness(Int)
    case startInstance
    case stopInstance
}

struct ApiError: Error {}

struct AppEnvironment {

}

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case .connect:
        state.api.connect()
        return .none
    case .adjustBrightness(let brightness):
        state.api.adjustBrightness(brightness)
        return .none
    case .startInstance:
        return .none
    case .stopInstance:
        return .none
    }
}
