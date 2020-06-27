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
        case didUpdateInstances([Instance])
        case didUpdateHostname(String)
        case didUpdateSelectedInstance(Int)
        case didDisconnect
    }

    var connect: (AnyHashable, URL) -> Effect<Action, Never>
    var disconnect: (AnyHashable) -> Effect<Action, Never>
    var sendMessage: (AnyHashable, ApiRequest) -> Effect<Action, Never>
    var subscribe: (AnyHashable) -> Effect<Action, Never>
    var updateBrightness: (AnyHashable, Double) -> Effect<Action, Never>
    var updateInstance: (AnyHashable, Int, Bool) -> Effect<Action, Never>
    var switchToInstance: (AnyHashable, Int) -> Effect<Action, Never>
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
                    },
                    didUpdateInstances: {
                        subscriber.send(.didUpdateInstances($0 as [Instance]))
                    },
                    didUpdateHostname: {
                        subscriber.send(.didUpdateHostname($0 as String))
                    },
                    didUpdateSelectedInstance: {
                        subscriber.send(.didUpdateSelectedInstance($0 as Int))
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
                dependencies[id]?.socket.write(string: string, completion: {
                    subscriber.send(completion: .finished)
                })
                return AnyCancellable {}
            }
        },
        subscribe: { id in
            .run { subscriber in
                let message = ApiSubscribeRequest(ApiRequest(command: .serverinfo), ApiSubscribeRequestData(subscribe: [.instanceUpdate, .adjustmentUpdate]))
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
                let message = ApiAdjustmentRequest(
                        ApiRequest(command: .adjustment),
                        ApiAdjustmentRequestData(adjustment: Adjustment(brightness: Int(brightness)))
                    )
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
        updateInstance: { id, instanceId, running in
            .run { subscriber in
                let message = ApiInstanceRequest(
                    ApiRequest(command: .instance),
                    ApiInstanceRequestData(subcommand: running ? .stopInstance : .startInstance, instance: instanceId)
                )
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
        switchToInstance: { id, instanceId in
            .run { subscriber in
                let message = ApiInstanceRequest(
                    ApiRequest(command: .instance),
                    ApiInstanceRequestData(subcommand: .switchTo, instance: instanceId)
                )
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
    let didUpdateInstances: ([Instance]) -> Void
    let didUpdateHostname: (String) -> Void
    let didUpdateSelectedInstance: (Int) -> Void


    init(
        didConnect: @escaping() -> Void,
        didDisconnect: @escaping() -> Void,
        didReceiveWebSocketEvent: @escaping (ApiEvent) -> Void,
        didUpdateBrightness: @escaping (Double) -> Void,
        didUpdateInstances: @escaping ([Instance]) -> Void,
        didUpdateHostname: @escaping (String) -> Void,
        didUpdateSelectedInstance: @escaping (Int) -> Void
    ) {
        self.didConnect = didConnect
        self.didDisconnect = didDisconnect
        self.didReceiveWebSocketEvent = didReceiveWebSocketEvent
        self.didUpdateBrightness = didUpdateBrightness
        self.didUpdateInstances = didUpdateInstances
        self.didUpdateHostname = didUpdateHostname
        self.didUpdateSelectedInstance = didUpdateSelectedInstance
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
            let response = try JSONDecoder().decode(ApiResponse.self, from: data)
            switch response {
            case .serverInfo(let serverInfo):
                self.didUpdateInstances(serverInfo.info.instances)
                self.didUpdateHostname(serverInfo.info.hostname)
                guard let adjustments = serverInfo.info.adjustments.first else { return }
                self.didUpdateBrightness(Double(adjustments.brightness))
            case .adjustmentUpdate(let adjustmentUpdate):
                guard let adjustment = adjustmentUpdate.data.first else { return }
                self.didUpdateBrightness(Double(adjustment.brightness))
            case .instanceUpdate(let instanceUpdate):
                self.didUpdateInstances(instanceUpdate.data)
            case .unknown:
                print("unknown")
            case .adjustmentResponse(let response), .instanceStart(let response), .instanceStop(let response):
                if !response.success {
                    print("Something went wrong")
                }
            case .instanceSwitch(let instance):
                self.didUpdateSelectedInstance(instance.info.instance)
            }
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
}
