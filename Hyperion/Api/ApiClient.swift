//
//  ApiClient.swift
//  Hyperion
//
//  Created by Hack, Thomas on 02.07.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Combine
import Starscream

private var dependencies: [AnyHashable: Dependencies] = [:]
private struct Dependencies {
    let socket: WebSocket
    let delegate: ApiClientDelegate
    let subscriber: Effect<Api.Action, Never>.Subscriber
}

struct ApiClient {

    enum Event: Equatable {
        case connected              // case connected([String: String])
        case disconnected           // case disconnected(String, UInt16)
        case text(String)           // case text(String)
        case binary(Data)           // case binary(Data)
        case ping                   // case ping(Data?)
        case pong                   // case pong(Data?)
        // case viabilityChanged    // case viabilityChanged(Bool)
        // reconnectSuggested       // case reconnectSuggested(Bool)
        case cancelled              // case cancelled
        case error(NSError?)        // case error(Error?)
    }

    var connect: (AnyHashable, URL) -> Effect<Api.Action, Never>
    var disconnect: (AnyHashable) -> Effect<Api.Action, Never>
    var sendMessage: (AnyHashable, HyperionApi.Request) -> Effect<Api.Action, Never>
    var subscribe: (AnyHashable) -> Effect<Api.Action, Never>
    var updateBrightness: (AnyHashable, Double) -> Effect<Api.Action, Never>
    var updateInstance: (AnyHashable, Int, Bool) -> Effect<Api.Action, Never>
    var updateColor: (AnyHashable, RGB) -> Effect<Api.Action, Never>
    var updateEffect: (AnyHashable, HyperionApi.Effect) -> Effect<Api.Action, Never>
    var toggleSmoothing: (AnyHashable, Bool) -> Effect<Api.Action, Never>
    var toggleBlackborderDetection: (AnyHashable, Bool) -> Effect<Api.Action, Never>
    var toggleLedHardware: (AnyHashable, Bool) -> Effect<Api.Action, Never>
    var toggleHdmiGrabber: (AnyHashable, Bool) -> Effect<Api.Action, Never>
    var toggleHdrToneMapping: (AnyHashable, Int) -> Effect<Api.Action, Never>
    var selectInstance: (AnyHashable, Int) -> Effect<Api.Action, Never>
    var clear: (AnyHashable) -> Effect<Api.Action, Never>
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
                        subscriber.send(.didReceiveWebSocketEvent($0 as Event))
                    },
                    didUpdateBrightness: {
                        subscriber.send(.didUpdateBrightness($0 as Double))
                    },
                    didUpdateInstances: {
                        subscriber.send(.didUpdateInstances($0 as [HyperionApi.Instance]))
                    },
                    didUpdateEffects: {
                        subscriber.send(.didUpdateEffects($0 as [HyperionApi.Effect]))
                    },
                    didUpdateComponent: {
                        subscriber.send(.didUpdateComponent($0 as HyperionApi.Component))
                    },
                    didUpdateComponents: {
                        subscriber.send(.didUpdateComponents($0 as [HyperionApi.Component]))
                    },
                    didUpdateHostname: {
                        subscriber.send(.didUpdateHostname($0 as String))
                    },
                    didUpdateSelectedInstance: {
                        subscriber.send(.didUpdateSelectedInstance($0 as Int))
                    },
                    didUpdatePriorities: {
                        subscriber.send(.didUpdatePriorities($0 as [HyperionApi.Priority]))
                    },
                    didUpdateHdrToneMapping: {
                        subscriber.send(.didUpdateHdrToneMapping($0 as Bool))
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
                let message = HyperionApi.SubscribeRequest(
                    HyperionApi.Request(command: .serverinfo),
                    HyperionApi.SubscribeRequestData(subscribe: [
                        .instanceUpdate,
                        .adjustmentUpdate,
                        .componentUpdate,
                        .priorityUpdate,
                        .videoModeHdrUpdate
                    ])
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
        updateBrightness: { id, brightness in
            .run { subscriber in
                let message = HyperionApi.AdjustmentRequest(
                    HyperionApi.Request(command: .adjustment),
                    HyperionApi.AdjustmentRequestData(adjustment: HyperionApi.Adjustment(brightness: Int(brightness)))
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
                let message = HyperionApi.InstanceRequest(
                    HyperionApi.Request(command: .instance),
                    HyperionApi.InstanceRequestData(subcommand: running ? .stopInstance : .startInstance, instance: instanceId)
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
        updateColor: { id, rgb in
            .run { subscriber in
                let message = HyperionApi.ColorRequest(
                    HyperionApi.Request(command: .color),
                    HyperionApi.ColorRequestData(color: [Int(rgb.red * 255), Int(rgb.green * 255), Int(rgb.blue * 255)], priority: 1, origin: "HyperionApp")
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
        updateEffect: { id, effect in
            .run { subscriber in
                let message = HyperionApi.EffectRequest(
                    HyperionApi.Request(command: .instance),
                    HyperionApi.EffectRequestData(effect: effect, priority: 50, origin: "HyperionApp")
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
        toggleSmoothing: { id, state in
            .run { subscriber in
                let message = HyperionApi.ComponentRequest(
                    HyperionApi.Request(command: .component),
                    HyperionApi.ComponentRequestData(componentstate: HyperionApi.ComponentState(component: .smoothing, state: state))
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
        toggleBlackborderDetection: { id, state in
            .run { subscriber in
                let message = HyperionApi.ComponentRequest(
                    HyperionApi.Request(command: .component),
                    HyperionApi.ComponentRequestData(componentstate: HyperionApi.ComponentState(component: .blackborder, state: state))
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
        toggleLedHardware: { id, state in
            .run { subscriber in
                let message = HyperionApi.ComponentRequest(
                    HyperionApi.Request(command: .component),
                    HyperionApi.ComponentRequestData(componentstate: HyperionApi.ComponentState(component: .led, state: state))
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
        toggleHdmiGrabber: { id, state in
            .run { subscriber in
                let message = HyperionApi.ComponentRequest(
                    HyperionApi.Request(command: .component),
                    HyperionApi.ComponentRequestData(componentstate: HyperionApi.ComponentState(component: .v4l, state: state))
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
        toggleHdrToneMapping: { id, state in
            .run { subscriber in
                let message = HyperionApi.HdrToneMappingRequest(
                    HyperionApi.Request(command: .hdr),
                    HyperionApi.HdrToneMappingRequestData(hdr: state)
                )
                do {
                    let data = try JSONEncoder().encode(message)
                    let string = String(data: data, encoding: .utf8)!
                    print("\(string)")
                    dependencies[id]?.socket.write(string: string)
                } catch {
                    print("error: \(error.localizedDescription)")
                    return AnyCancellable{}
                }
                return AnyCancellable{}
            }
        },
        selectInstance: { id, instanceId in
            .run { subscriber in
                let message = HyperionApi.InstanceRequest(
                    HyperionApi.Request(command: .instance),
                    HyperionApi.InstanceRequestData(subcommand: .switchTo, instance: instanceId)
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
        clear: { id in
            .run { subscriber in
                let message = HyperionApi.ClearRequest(
                    HyperionApi.Request(command: .clear),
                    HyperionApi.ClearRequestData(priority: -1)
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
