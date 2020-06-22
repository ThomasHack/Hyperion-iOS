//
//  ApiReducer.swift
//  Hyperion
//
//  Created by Hack, Thomas on 14.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import Foundation
import ComposableArchitecture

let apiReducer = Reducer<ApiState, ApiAction, ApiEnvironment> {state, action, environment in
    struct ApiId: Hashable {}

    var receiveSocketMessageEffect: Effect<ApiAction, Never> {
        return environment.webSocket.receive(ApiId())
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(ApiAction.receivedSocketMessage)
            .cancellable(id: ApiId())
    }

    var sendPingEffect: Effect<ApiAction, Never> {
        return environment.webSocket.sendPing(ApiId())
            .delay(for: 10, scheduler: environment.mainQueue)
            .map(ApiAction.pingResponse)
            .eraseToEffect()
            .cancellable(id: ApiId())
    }

    switch action {
    case .alertDismissed:
        state.alert = nil
        return .none

    case .connectButtonTapped:
        switch state.connectivityState {
        case .connected, .connecting:
            state.connectivityState = .disconnected
            return .cancel(id: ApiId())

        case .disconnected:
            state.connectivityState = .connecting
            return environment.webSocket.connect(ApiId(), URL(string: "ws://hyperion.home:8090")!, [])
                .receive(on: environment.mainQueue)
                .map(ApiAction.webSocket)
                .eraseToEffect()
                .cancellable(id: ApiId())
        }

    case let .messageToSendChanged(message):
        state.messageToSend = message
        return .none

    case .pingResponse:
        // Ping the socket again in 10 seconds
        return sendPingEffect

    case let .receivedSocketMessage(.success(.string(string))):
        state.receivedMessages.append(string)
        // Immediately ask for the next socket message
        return receiveSocketMessageEffect

    case .receivedSocketMessage(.success):
        // Immediately ask for the next socket message
        return receiveSocketMessageEffect

    case .receivedSocketMessage(.failure):
        return .none

    case .sendButtonTapped:
        let messageToSend = state.messageToSend
        state.messageToSend = ""

        return environment.webSocket.sendString(ApiId(), messageToSend)
            .eraseToEffect()
            .map(ApiAction.sendResponse)

    case let .sendResponse(error):
        if error != nil {
            state.alert = "Could not send socket message. Try again."
        }
        return .none

    case .webSocket(.didConnect):
        state.connectivityState = .connected
        return .merge(
            receiveSocketMessageEffect,
            sendPingEffect
        )

    case let .webSocket(.didDisconnect(code, _)):
        state.connectivityState = .disconnected
        return .cancel(id: ApiId())

    case let .webSocket(.didBecomeInvalidWithError(error)), let .webSocket(.didCompleteWithError(error)):
        state.connectivityState = .disconnected
        if error != nil {
            state.alert = "Disconnected from socket for some reason. Try again."
        }
        return .cancel(id: ApiId())

    case let .webSocket(.didReceiveMessage(message)):
        state.receivedMessages.append(message)
        // Immediately ask for the next socket message
        return receiveSocketMessageEffect
    }
}.debug()
