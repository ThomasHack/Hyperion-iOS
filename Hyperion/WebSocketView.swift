//
//  WebSocketView.swift
//  Hyperion
//
//  Created by Hack, Thomas on 14.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

// MARK: - WebSocketView

struct WebSocketView: View {
    let store: Store<ApiState, ApiAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(alignment: .leading) {

                HStack {
                    TextField(
                        "Message to send",
                        text: viewStore.binding(
                            get: { $0.messageToSend }, send: ApiAction.messageToSendChanged)
                    )

                    Button(
                        viewStore.connectivityState == .connected
                            ? "Disconnect"
                            : viewStore.connectivityState == .disconnected
                            ? "Connect"
                            : "Connecting..."
                    ) {
                        viewStore.send(.connectButtonTapped)
                    }
                }

                Spacer().frame(height: 10)

                Button("Send message") {
                    viewStore.send(.sendButtonTapped)
                }

                Spacer().frame(height: 10)

                Text("Status: \(viewStore.connectivityState.rawValue)")
                    .foregroundColor(.secondary)
                Text("Received messages:")
                    .foregroundColor(.secondary)
                Text(viewStore.receivedMessages.joined(separator: "\n"))

                Spacer()
            }
            .padding()
            .navigationBarTitle("Web Socket")
        }
    }
}

struct WebSocketView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WebSocketView(
                store: Store(
                    initialState: .init(receivedMessages: ["Echo"]),
                    reducer: apiReducer,
                    environment: ApiEnvironment(
                        mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                        webSocket: .live
                    )
                )
            )
        }
    }
}

