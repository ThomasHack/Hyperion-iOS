//
//  API.swift
//  Hyperion
//
//  Created by Hack, Thomas on 13.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import Starscream

// MARK: - AppEnvironment

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var webSocket: APIClient
}

// MARK: - APIState

struct APIState: Equatable {
    var connectivityState = ConnectivityState.disconnected
    var messageToSend = ""
    var receivedMessages: [String] = []

    enum ConnectivityState: String {
      case connected
      case connecting
      case disconnected
    }
}

// MARK: - APIClient

struct APIClient {
    enum Action: Equatable {
        static func == (lhs: APIClient.Action, rhs: APIClient.Action) -> Bool {
            return false
        }

        case didReceiveEvent(WebSocketEvent, WebSocket)
    }

    var connect: (AnyHashable, URL, [String]) -> Effect<Action, Never>
    var disconnect: (AnyHashable) -> Effect<NSError?, Never>
    var receive: (AnyHashable) -> Effect<WebSocketEvent, NSError>
    var sendString: (AnyHashable, String) -> Effect<NSError?, Never>
    var sendData: (AnyHashable, Data) -> Effect<NSError?, Never>
}

extension APIClient {
    static let live = APIClient(
        connect: { id, url, protocols in
            Effect.run { subscriber in
                let delegate = APIDelegate(
                    didReceiveEvent: {
                        subscriber.send(.didReceiveEvent($0 as WebSocketEvent, $1 as WebSocket))
                })
                let socket = WebSocket(request: URLRequest(url: URL(string: "http://localhost:8080")!))
                dependencies[id] = Dependencies(delegate: delegate,
                                                subscriber: subscriber,
                                                socket: socket)
                return AnyCancellable {
                    dependencies[id]?.subscriber.send(completion: .finished)
                    dependencies[id] = nil
                }
            }
        },
        disconnect: { id in
            .future { callback in
                dependencies[id]?.socket.disconnect()
            }
        },
        receive: { id in
            .future { callback in
                dependencies[id]?.socket.didReceive(event: WebSocketEvent) {
                    switch event {
                    case .connected(let headers):
                        isConnected = true
                        print("websocket is connected: \(headers)")
                    case .disconnected(let reason, let code):
                        isConnected = false
                        print("websocket is disconnected: \(reason) with code: \(code)")
                    case .text(let string):
                        print("Received text: \(string)")
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
            }
        },
        sendString: { id, string in
            .future { callback in
                dependencies[id]?.socket.write(string: string)
            }
        },
        sendData: { id, data in
            .future { callback in
                dependencies[id]?.socket.write(data: data)
            }
        }
    )
}

let apiReducer = Reducer<AppState, AppAction, AppEnvironment> {state, action, environment in
    struct ApiId: Hashable {}

    /* var receiveSocketMessageEffect: Effect<WebSocketAction, Never> {
        return environment.webSocket.receive(ApiId())
        // .receive(on: environment.mainQueue)
        .catchToEffect()
        .map(AppAction.receivedMessage)
        // .cancellable(id: ApiId())
    } */

    switch action {
    case .connectButtonTapped:
        print("connectButtonTapped")
    case .messageToSendChanged(let string):
        print("messageToSendChanged \(string)")
    case .receivedMessage(let string):
        print("receivedMessage")
        // return receiveSocketMessageEffect
    case .sendButtonTapped:
        print("sendButtonTapped")
    }

    func serverInfo() {
        // let action = "{\"command\":\"serverinfo\",\"tan\":1}"
        let action = "{\"command\":\"serverinfo\",\"subscribe\":[\"instance-update\",\"adjustment-update\"],\"tan\":1}"
        sendAction(action)
    }

    func subscribeUpdates() {
        let action = "{\"command\":\"serverinfo\",\"subscribe\":[\"instance-update\",\"adjustment-update\"],\"tan\":1}"
        sendAction(action)
    }

    func adjustBrightness(_ brightness: Int) {
        let action = "{\"command\":\"adjustment\",\"adjustment\":{\"brightness\":\(brightness)}}"
        sendAction(action)
    }

    func startInstance(_ instance: Int) {
        let action = "{\"command\":\"instance\",\"subcommand\":\"startInstance\",\"instance\":\"\(instance)\"}"
        sendAction(action)
    }

    func stopInstance(_ instance: Int) {
        let action = "{\"command\":\"instance\",\"subcommand\":\"stopInstance\",\"instance\":\"\(instance)\"}"
        sendAction(action)
    }

    func sendAction(_ action: String) {
        /* if isConnected, let socket = socket {
            socket.write(string: action)
        } */
    }
}.debug()

private class APIDelegate: WebSocketDelegate {

    let didReceiveEvent: (WebSocketEvent, WebSocket) -> Void

    init(didReceiveEvent: @escaping  (WebSocketEvent, WebSocket) -> Void) {
        self.didReceiveEvent = didReceiveEvent
    }

    func didReceive(event: WebSocketEvent, client: WebSocket) {
        self.didReceiveEvent(event, client)
    }
}

private var dependencies: [AnyHashable: Dependencies] = [:]
private struct Dependencies {
  let delegate: WebSocketDelegate
  let subscriber: Effect<APIClient.Action, Never>.Subscriber
  let socket: WebSocket
}
