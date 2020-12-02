//
//  Favourites.swift
//  Hyperion
//
//  Created by Hack, Thomas on 14.08.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct Favourites: View {
    let store: Store<Control.ControlFeatureState, Control.Action>

    let columns = [
            GridItem(.adaptive(minimum: 150))
        ]
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            LazyVGrid(columns: columns, spacing: 8) {

            }
        }
    }
}

struct Favourites_Previews: PreviewProvider {
    static var previews: some View {
        Favourites(store: Main.store.control)
    }
}
