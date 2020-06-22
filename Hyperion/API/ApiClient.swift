//
//  ApiClient.swift
//  Hyperion
//
//  Created by Hack, Thomas on 14.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Starscream
import Combine

// MARK: - ApiClient

struct ApiClient {
    enum Action: Equatable {
        case didConnect(headers: [String : String])
        case didDisconnect(code: Int, reason: String)
        case didCompleteWithError(NSError?)
        case didBecomeInvalidWithError(NSError?)
        case didReceiveMessage(message: String)
    }

    enum Message: Equatable {
        case data(Data)
        case string(String)

        init?(_ message: URLSessionWebSocketTask.Message) {
            switch message {
            case let .data(data):
                self = .data(data)
            case let .string(string):
                self = .string(string)
            @unknown default:
                return nil
            }
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case let (.data(lhs), .data(rhs)):
                return lhs == rhs
            case let (.string(lhs), .string(rhs)):
                return lhs == rhs
            case (.data, _), (.string, _):
                return false
            }
        }
    }

    var connect: (AnyHashable, URL, [String]) -> Effect<Action, Never>
    var receive: (AnyHashable) -> Effect<Message, NSError>
    var sendString: (AnyHashable, String) -> Effect<NSError?, Never>
    var sendData: (AnyHashable, Data) -> Effect<NSError?, Never>
    var sendPing: (AnyHashable) -> Effect<NSError?, Never>
    // var cancel: (AnyHashable, URLSessionWebSocketTask.CloseCode, Data?) -> Effect<Never, Never>
}

extension ApiClient {
    static let live = ApiClient(
        connect: { id, url, protocols in
            Effect.run { subscriber in
                let delegate = ApiDelegate(
                    didConnect: { subscriber.send(.didConnect(headers: $0)) },
                    didDisconnect: { subscriber.send(.didDisconnect(code: $0, reason: $1)) },
                    didCompleteWithError: { subscriber.send(.didCompleteWithError($0 as NSError?))},
                    didBecomeInvalidWithError: { subscriber.send(.didBecomeInvalidWithError($0 as NSError?)) },
                    didReceiveMessage: { subscriber.send(.didReceiveMessage(message: $0))}
                )

                let request = URLRequest(url: url)
                let socket = WebSocket(request: request)
                socket.delegate = delegate
                socket.connect()
                print("\(url)")
                dependencies[id] = Dependencies(delegate: delegate, subscriber: subscriber, socket: socket)
                return AnyCancellable {
                    dependencies[id]?.subscriber.send(completion: .finished)
                    dependencies[id] = nil
                }
            }
        },
        receive: { id in
            .future { callback in
                print("asdasdasd")
                
                /* dependencies[id]?.task.receive { result in
                    print("/(result)")
                    switch result.map(Message.init) {
                    case let .success(.some(message)):
                        callback(.success(message))
                    case .success(.none):
                        callback(.failure(NSError.init(domain: "de.thomashack", code: 1)))
                    case let .failure(error):
                        callback(.failure(error as NSError))
                    }
                } */
            }
        },
        sendString: { id, message in
            .future { callback in
                dependencies[id]?.socket.write(string: message)
            }
        },
        sendData: { id, message in
            .future { callback in
                dependencies[id]?.socket.write(data: message)
            }
        },
        sendPing: { id in
            .future { callback in
                dependencies[id]?.socket.write(ping: Data())
        }
    })
}

// MARK: - Dependencies

private var dependencies: [AnyHashable: Dependencies] = [:]

private struct Dependencies {
    let delegate: ApiDelegate
    let subscriber: Effect<ApiClient.Action, Never>.Subscriber
    let socket: WebSocket
}
