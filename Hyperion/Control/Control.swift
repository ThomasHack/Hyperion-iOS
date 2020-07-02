//
//  Control.swift
//  Hyperion
//
//  Created by Hack, Thomas on 02.07.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import UIKit

enum Control {
    struct State: Equatable {
        var showEffectPopover: Bool = false
        var selectedEffect: String = ""
        var rgbColor: RGB = RGB(r: 0, g: 0, b: 0)
        var brightness: CGFloat = 1
    }

    enum Action {
        case showEffectPopover
        case hideEffectPopover
        case toggleEffectPopover(Bool)
        case didChangeEffect(String)
        case updateColor(RGB)
        case updateBrightness(CGFloat)
        case clearButtonTapped

        case api(Api.Action)
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<ControlFeatureState, Action, Environment>.combine(
        Reducer { state, action, environment in
            switch action {
            case .showEffectPopover:
                state.showEffectPopover = true

            case .hideEffectPopover:
                state.showEffectPopover = false

            case .toggleEffectPopover(let toggle):
                state.showEffectPopover = toggle

            case .didChangeEffect(let effect):
                state.selectedEffect = effect

            case .updateColor(let color):
                state.rgbColor = color
                //return Effect(value: Action.api(.updateColor(color)))

            case .updateBrightness(let brightness):
                state.brightness = brightness

            case .clearButtonTapped:
                return Effect(value: Action.api(.clear))

            case .api:
                return .none
            }
            return .none
        }.debug(),
        Api.reducer.pullback(
            state: \ControlFeatureState.api,
            action: /Action.api,
            environment: { $0 }
        )
    )

    static let initialState = State()
}
