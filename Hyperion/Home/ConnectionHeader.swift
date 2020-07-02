//
//  ConnectionHeader.swift
//  Hyperion
//
//  Created by Hack, Thomas on 27.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct ConnectionHeader: View {
    let store: Store<Home.HomeFeatureState, Home.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(alignment: .leading, spacing: 8) {
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

                Spacer()
                    .frame(height: 8.0)
            }
        }
    }
}

struct ConnectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionHeader(store: Main.store.home)
        .previewLayout(.fixed(width: 375, height: 40))
    }
}
