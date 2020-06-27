//
//  ConnectionHeader.swift
//  Hyperion
//
//  Created by Hack, Thomas on 27.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

extension HomeView {

    struct ConnectionHeader: View {
        var store: Store<AppState, AppAction>

        var body: some View {
            WithViewStore(self.store) { viewStore in
                HStack(alignment: .center, spacing: 8) {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(
                            Color(viewStore.connectivityState == .connected
                                    ? UIColor.systemGreen
                                    : viewStore.connectivityState == .disconnected
                                    ? UIColor.systemRed
                                    : UIColor.systemOrange)
                        )
                    Text(
                        viewStore.connectivityState == .connected
                            ? "Status: Connected to \(viewStore.hostname)"
                            : viewStore.connectivityState == .disconnected
                            ? "Status: Disconnected"
                            : "Status: Connecting...")
                        .font(.system(size: 13))
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}

struct ConnectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        HomeView.ConnectionHeader(
            store: Store(
                initialState: AppState(
                    connectivityState: .connected,
                    hostname: "Preview"
                ),
                reducer: appReducer,
                environment: AppEnvironment(
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                    apiClient: .live
                )
            )
        )
        .previewLayout(.fixed(width: 375, height: 40))
    }
}
