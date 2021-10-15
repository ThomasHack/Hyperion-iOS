//
//  Api+Action.swift
//  Hyperion
//
//  Created by Hack, Thomas on 15.10.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation
import HyperionApi

extension Api {
    enum Action: Equatable {
        case connect(URL)
        case disconnect
        case subscribe
        case selectInstance(Int)
        case updateInstance(Int, Bool)
        case updateBrightness(Double)
        case updateColor(HyperionApi.RGB)
        case updateEffect(HyperionApi.LightEffect)
        case toggleAll(Bool)
        case toggleSmoothing(Bool)
        case toggleBlackborderDetection(Bool)
        case toggleLedHardware(Bool)
        case toggleHdmiGrabber(Bool)
        case toggleHdrToneMapping(Bool)
        case clear

        case didConnect
        case didDisconnect
        case didSubscribe
        case didReceiveWebSocketEvent(HyperionApi.ApiEvent)
        case didUpdateBrightness(Double)
        case didUpdateInstances([HyperionApi.Instance])
        case didUpdateEffects([HyperionApi.LightEffect])
        case didUpdateComponent(HyperionApi.Component)
        case didUpdateComponents([HyperionApi.Component])
        case didUpdateHostname(String)
        case didUpdateSelectedInstance(Int)
        case didUpdatePriorities([HyperionApi.Priority])
        case didUpdateHdrToneMapping(Bool)
    }
}
