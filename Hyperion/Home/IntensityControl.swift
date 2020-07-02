//
//  IntensityControl.swift
//  Hyperion
//
//  Created by Hack, Thomas on 27.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct IntensityControl: View {
    let store: Store<Home.HomeFeatureState, Home.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(alignment: .leading, spacing: 8) {
                SectionHeader(text: "Intensity")

                HStack(alignment: .center, spacing: 8.0) {
                    if let smoothing = viewStore.api.smoothingComponent {
                        IntensityButton(
                            imageName: "rays",
                            text: "Subtle",
                            isDisabled: false, //smoothing.enabled,
                            isRunning: smoothing.enabled,
                            callback: {
                                viewStore.send(.turnOnSmoothing)
                            })

                        IntensityButton(
                            imageName: "tornado",
                            text: "Extreme",
                            isDisabled: false, //!smoothing.enabled,
                            isRunning: !smoothing.enabled,
                            callback: {
                                viewStore.send(.turnOffSmoothing)
                            })
                    } else {
                        Text("Smoothing unavailable")
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

struct IntensityControl_Previews: PreviewProvider {
    static var previews: some View {
        IntensityControl(store: Main.store.home)
        .previewLayout(.fixed(width: 375, height: 160))
    }
}
