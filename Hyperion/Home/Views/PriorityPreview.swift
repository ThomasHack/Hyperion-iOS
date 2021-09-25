//
//  PriorityPreview.swift
//  Hyperion
//
//  Created by Hack, Thomas on 13.08.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct PriorityPreview: View {
    let store: Store<Home.HomeFeatureState, Home.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
                viewStore.api.currentColor
                    .frame(width: 30, height: 30)
        }
    }
}

struct PriorityPreview_Previews: PreviewProvider {
    static var previews: some View {
        PriorityPreview(store: Main.store.home)
    }
}
