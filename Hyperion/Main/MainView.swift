//
//  MainView.swift
//  Hyperion
//
//  Created by Hack, Thomas on 27.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct MainView: View {
    var store: Store<Main.State, Main.Action>

    var body: some View {
        WithViewStore(self.store) { _ in
            HomeView(store: Main.store.home)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(store: Main.store)
    }
}
