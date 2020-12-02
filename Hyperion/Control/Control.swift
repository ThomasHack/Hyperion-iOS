//
//  Control.swift
//  Hyperion
//
//  Created by Hack, Thomas on 02.07.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import UIKit
import SwiftUI

enum Control {
    struct State: Equatable {
        var showEffectPopover: Bool = false
        var selectedEffect: String = ""
        var rgbColor: RGB = RGB(red: 255, green: 255, blue: 255)
        var color: Color = Color.red
        var brightness: CGFloat = 1
    }

    enum Action {
        case showEffectPopover
        case hideEffectPopover
        case toggleEffectPopover(Bool)
        case didChangeEffect(String)
        case updateColor(Color)
        case updateBrightness(CGFloat)
        case clearButtonTapped
        case void

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
                state.color = color
                state.rgbColor = color.rgbColor
                return Effect(value: Action.api(.updateColor(color.rgbColor)))

            case .updateBrightness(let brightness):
                state.brightness = brightness
                return Effect(value: Action.api(.updateBrightness(Double(brightness*100))))

            case .clearButtonTapped:
                return Effect(value: Action.api(.clear))

            case .void:
                break

            case .api:
                break
            }
            return .none
        },
        Api.reducer.pullback(
            state: \ControlFeatureState.api,
            action: /Action.api,
            environment: { $0 }
        )
    )

    static let initialState = State()
}
