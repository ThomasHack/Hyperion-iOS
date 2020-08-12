//
//  BlackborderControl.swift
//  Hyperion
//
//  Created by Hack, Thomas on 27.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct BlackborderControl: View {
    let store: Store<Home.HomeFeatureState, Home.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(alignment: .leading, spacing: 8) {
                SectionHeader(text: "Intensity")

                HStack(alignment: .center, spacing: 8.0) {
                    if let blackborderDetection = viewStore.api.blackborderComponent {
                        IntensityButton(
                            imageName: "checkmark.circle.fill",
                            text: "Subtle",
                            isDisabled: false, //blackborderDetection.enabled,
                            isRunning: blackborderDetection.enabled,
                            callback: {
                                viewStore.send(.turnOnBlackborderDetection)
                            })

                        IntensityButton(
                            imageName: "multiply.circle.fill",
                            text: "Extreme",
                            isDisabled: false, //!blackborderDetection.enabled,
                            isRunning: !blackborderDetection.enabled,
                            callback: {
                                viewStore.send(.turnOffBlackborderDetection)
                            })
                    } else {
                        Text("Blackborder Detection unavailable")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                Spacer()
                    .frame(height: 16.0)
            }
        }
    }
}

struct BlackborderControl_Previews: PreviewProvider {
    static var previews: some View {
        IntensityControl(store: Main.store.home)
        .previewLayout(.fixed(width: 375, height: 160))
    }
}
