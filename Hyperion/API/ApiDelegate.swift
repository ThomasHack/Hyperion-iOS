//
//  ApiDelegate.swift
//  Hyperion
//
//  Created by Hack, Thomas on 14.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import Foundation
import Starscream

// MARK: - ApiDelegate

class ApiDelegate: WebSocketDelegate {

    let didConnect: ([String : String]) -> Void
    let didDisconnect: (Int, String) -> Void
    let didCompleteWithError: (Error?) -> Void
    let didBecomeInvalidWithError: (Error?) -> Void
    let didReceiveMessage: (String) -> Void

    init(
        didConnect: @escaping ([String : String]) -> Void,
        didDisconnect: @escaping (Int, String) -> Void,
        didCompleteWithError: @escaping (Error?) -> Void,
        didBecomeInvalidWithError: @escaping (Error?) -> Void,
        didReceiveMessage: @escaping (String) -> Void
    ) {
        self.didConnect = didConnect
        self.didDisconnect = didDisconnect
        self.didCompleteWithError = didCompleteWithError
        self.didBecomeInvalidWithError = didBecomeInvalidWithError
        self.didReceiveMessage = didReceiveMessage
    }

    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            print("websocket is connected: \(headers)")
            self.didConnect(headers)
        case .disconnected(let reason, let code):
            print("websocket is disconnected: \(reason) with code: \(code)")
            self.didDisconnect(Int(code), reason)
        case .text(let string):
            print("Received text: \(string)")
            self.didReceiveMessage(string)
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            // self.didBecomeInvalidWithError(error)
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            break
        case .error(let error):
            self.didCompleteWithError(error)
        }
    }
}
