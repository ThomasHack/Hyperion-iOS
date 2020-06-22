//
//  API.swift
//  Hyperion
//
//  Created by Hack, Thomas on 13.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import Foundation
import Starscream

enum APIUpdates {
    case instanceUpdates
    case adjustmentUpdates
}

class API: ApiDelegate, ObservableObject, Equatable {
    static func == (lhs: API, rhs: API) -> Bool {
        return false
    }

    private var socket: WebSocket?
    private var isConnected: Bool = false

    @Published var instances: [Instance] = []
    @Published var hostname: String = ""
    @Published var brightness: Int = 0

    func connect() {
        var request = URLRequest(url: URL(string: "ws://hyperion.home:8090")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }

    internal override func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            serverInfo()
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            let decoder = JSONDecoder()
            do {
                let jsonData = string.data(using: String.Encoding.utf8)!
                let response = try decoder.decode(APIResponse.self, from: jsonData)
                if let info = response.info, let data = response.data?.first {
                    self.instances = info.instances
                    self.hostname = info.hostname
                    self.brightness = data.brightness
                }
                print("\(String.init(describing: response))")
            } catch {
                print("Parsing failed: \(string)")
            }
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            isConnected = false
            handleError(error)
        }
    }

    private func handleError(_ error: Error?) {
        print("\(String(describing: error))")
    }

    public func serverInfo() {
        // let action = "{\"command\":\"serverinfo\",\"tan\":1}"
        let action = "{\"command\":\"serverinfo\",\"subscribe\":[\"instance-update\",\"adjustment-update\"],\"tan\":1}"
        sendAction(action)
    }

    public func subscribeUpdates() {
        let action = "{\"command\":\"serverinfo\",\"subscribe\":[\"instance-update\",\"adjustment-update\"],\"tan\":1}"
        sendAction(action)
    }

    public func adjustBrightness(_ brightness: Int) {
        let action = "{\"command\":\"adjustment\",\"adjustment\":{\"brightness\":\(brightness)}}"
        sendAction(action)
    }

    public func startInstance(_ instance: Int) {
        let action = "{\"command\":\"instance\",\"subcommand\":\"startInstance\",\"instance\":\"\(instance)\"}"
        sendAction(action)
    }

    public func stopInstance(_ instance: Int) {
        let action = "{\"command\":\"instance\",\"subcommand\":\"stopInstance\",\"instance\":\"\(instance)\"}"
        sendAction(action)
    }

    private func sendAction(_ action: String) {
        if isConnected, let socket = socket {
            socket.write(string: action)
        }
    }
}
