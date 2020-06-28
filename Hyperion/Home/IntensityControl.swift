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
    let store: Store<Home.State, Home.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(alignment: .leading, spacing: 8) {
                SectionHeader(text: "Intensity")

                HStack(alignment: .center, spacing: 8.0) {
                    IntensityButton(imageName: "rays", text: "Subtle", callback: {})
                    IntensityButton(imageName: "slowmo", text: "Moderate", callback: {})
                    IntensityButton(imageName: "wind", text: "High", callback: {})
                    IntensityButton(imageName: "tornado", text: "Extreme", callback: {})
                }

                Spacer()
                    .frame(height: 16.0)
            }
        }
    }
}

struct IntensityControl_Previews: PreviewProvider {
    static var previews: some View {
        IntensityControl(
            store: Main.initialStore.homeStore
        )
        .previewLayout(.fixed(width: 375, height: 140))
    }
}
