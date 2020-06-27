//
//  IntensityControl.swift
//  Hyperion
//
//  Created by Hack, Thomas on 27.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

extension HomeView {

    struct IntensityControl: View {
        var store: Store<HomeState, HomeAction>

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
                }
            }
        }
    }
}

struct IntensityControl_Previews: PreviewProvider {
    static var previews: some View {
        HomeView.IntensityControl(
            store: Store(
                initialState: HomeState(),
                reducer: homeReducer,
                environment: MainEnvironment(
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                    apiClient: .live
                )
            )
        )
        .previewLayout(.fixed(width: 375, height: 140))
    }
}
