//
//  BrightnessControl.swift
//  Hyperion
//
//  Created by Hack, Thomas on 27.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct BrightnessControl: View {
    let store: Store<Home.State, Home.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(alignment: .leading, spacing: 8) {
                SectionHeader(text: "Brightness")

                BrightnessSlider(percentage: viewStore.binding( get: { $0.brightness }, send: Home.Action.updateBrightness))
                    .frame(height: 72)

                Spacer()
                    .frame(height: 16.0)
            }
        }
    }
}

struct BrightnessControl_Previews: PreviewProvider {
    static var previews: some View {
        BrightnessControl(
            store: Main.initialStore.homeStore
        )
        .previewLayout(.fixed(width: 375, height: 120))
    }
}
