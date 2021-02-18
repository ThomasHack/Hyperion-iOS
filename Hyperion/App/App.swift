//
//  App.swift
//  Hyperion
//
//  Created by Hack, Thomas on 18.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation
import ComposableArchitecture

enum App {
    struct State: Equatable {}

    enum Action {
        case api(Api.Action)
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<AppFeatureState, Action, Environment>.combine(
        Reducer { state, action, environment in
            switch action {
            case .api:
                return .none
            }
        },
        Api.reducer.pullback(
            state: \AppFeatureState.api,
            action: /Action.api,
            environment: { $0 }
        )
    )

    static let initialState = State()
}
