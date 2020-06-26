//
//  ApiClient.swift
//  Hyperion
//
//  Created by Hack, Thomas on 26.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Combine
import Starscream

enum ApiEvent: Equatable {
    case connected              // case connected([String: String])
    case disconnected           // case disconnected(String, UInt16)
    case text(String)           // case text(String)
    case binary(Data)           // case binary(Data)
    case ping                // case ping(Data?)
    // case pong                // case pong(Data?)
    // case viabilityChanged    // case viabilityChanged(Bool)
    // reconnectSuggested       // case reconnectSuggested(Bool)
    case cancelled              // case cancelled
    case error(NSError?)        // case error(Error?)
}

struct ApiClient {
    enum Action: Equatable {
        case didConnect
        case didReceiveWebSocketEvent(ApiEvent)
        case didUpdateBrightness(Double)
        case didDisconnect
    }

    var connect: (AnyHashable, URL) -> Effect<Action, Never>
    var disconnect: (AnyHashable) -> Effect<Action, Never>
    var sendMessage: (AnyHashable, ApiRequest) -> Effect<Action, Never>
    var subscribe: (AnyHashable) -> Effect<Action, Never>
    var updateBrightness: (AnyHashable, Double) -> Effect<Action, Never>

    // "{\"command\":\"instance\",\"subcommand\":\"startInstance\",\"instance\":\"\(instance)\"}"
    // "{\"command\":\"instance\",\"subcommand\":\"stopInstance\",\"instance\":\"\(instance)\"}"
}

private var dependencies: [AnyHashable: Dependencies] = [:]
private struct Dependencies {
    let socket: WebSocket
    let delegate: WebSocketDelegate
    let subscriber: Effect<ApiClient.Action, Never>.Subscriber
}

extension ApiClient {
    static let live = ApiClient(
        connect: { id, url in
            .run { subscriber in
                let delegate = ApiClientDelegate(
                    didConnect: {
                        subscriber.send(.didConnect)
                    },
                    didDisconnect: {
                        subscriber.send(.didDisconnect)
                    },
                    didReceiveWebSocketEvent: {
                        subscriber.send(.didReceiveWebSocketEvent($0 as ApiEvent))
                    },
                    didUpdateBrightness: {
                        subscriber.send(.didUpdateBrightness($0 as Double))
                    }
                )
                let request = URLRequest(url: url)
                let socket = WebSocket(request: request)
                socket.delegate = delegate
                socket.connect()
                dependencies[id] = Dependencies(socket: socket, delegate: delegate, subscriber: subscriber)
                return AnyCancellable {
                    dependencies[id]?.subscriber.send(completion: .finished)
                    dependencies[id] = nil
                }
            }
        },
        disconnect: { id in
            .run { subscriber in
               print("ApiClient.disconnect")
                dependencies[id]?.socket.disconnect()
                dependencies[id]?.subscriber.send(.didDisconnect)
                return AnyCancellable {
                    dependencies[id]?.subscriber.send(completion: .finished)
                    dependencies[id] = nil
                }
            }
        },
        sendMessage: { id, message in
            .run { subscriber in
                let data = try! JSONEncoder().encode(message)
                let string = String(data: data, encoding: .utf8)!
                print("ApiClient.send \(string)")
                dependencies[id]?.socket.write(string: string, completion: {
                    subscriber.send(completion: .finished)
                })
                return AnyCancellable {}
            }
        },
        subscribe: { id in
            .run { subscriber in
                let message = ApiRequest(command: .serverInfo, subscribe: [.adjustmentUpdate, .instanceUpdate])
                do {
                    let data = try JSONEncoder().encode(message)
                    let string = String(data: data, encoding: .utf8)!
                    dependencies[id]?.socket.write(string: string)
                } catch {
                    print("error: \(error.localizedDescription)")
                    return AnyCancellable{}
                }
                return AnyCancellable{}
            }
        },
        updateBrightness: { id, brightness in
            .run { subscriber in
                let message = ApiRequest(command: .adjustment, adjustment: AdjustmentData(brightness: brightness))
                do {
                    let data = try JSONEncoder().encode(message)
                    let string = String(data: data, encoding: .utf8)!
                    dependencies[id]?.socket.write(string: string)
                } catch {
                    print("error: \(error.localizedDescription)")
                    return AnyCancellable{}
                }
                return AnyCancellable{}
            }
        }
    )
}

class ApiClientDelegate: WebSocketDelegate {
    let didConnect: () -> Void
    let didDisconnect: () -> Void
    let didReceiveWebSocketEvent: (ApiEvent) -> Void
    let didUpdateBrightness: (Double) -> Void


    init(
        didConnect: @escaping() -> Void,
        didDisconnect: @escaping() -> Void,
        didReceiveWebSocketEvent: @escaping (ApiEvent) -> Void,
        didUpdateBrightness: @escaping (Double) -> Void
    ) {
        self.didConnect = didConnect
        self.didDisconnect = didDisconnect
        self.didReceiveWebSocketEvent = didReceiveWebSocketEvent
        self.didUpdateBrightness = didUpdateBrightness
    }

    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected:
            self.didConnect()
        case .disconnected, .cancelled:
            self.didDisconnect()
        case .text(let string):
            self.didReceiveText(string)
        case .binary(let data):
            print("ApiClientDelegate.didReceive.data: \(data.count)")
            self.didReceiveWebSocketEvent(.binary(data))
        case .ping(_):
            print("ApiClientDelegate.didReceive.ping")
            self.didReceiveWebSocketEvent(.ping)
        case .pong(_):
            print("ApiClientDelegate.didReceive.pong")
        case .viabilityChanged(_):
            print("ApiClientDelegate.didReceive.viabilityChanged")
        case .reconnectSuggested(_):
            print("ApiClientDelegate.didReceive.reconnectSuggested")
        case .error(let error):
            print("ApiClientDelegate.didReceive.error: error \(error!.localizedDescription)")
            self.didReceiveWebSocketEvent(.error(error as NSError?))
        }
    }

    private func didReceiveText(_ string: String) {
        guard let data = string.data(using: .utf8, allowLossyConversion: false) else { return }
        do {
            let message = try JSONDecoder().decode(ApiResponse.self, from: data)
            switch message.command {
            case .adjustment:
                break
            case .adjustmentUpdate:
                guard let data = message.data, let adjustment = data.first else { return }
                self.didUpdateBrightness(adjustment.brightness)
            case .instanceUpdate:
                break
            case .serverInfo:
                break
            }
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }

    // private func didReceive
}
