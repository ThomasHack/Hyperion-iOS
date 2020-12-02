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

    enum ViewKind: Hashable {
        case home, control
    }

    @State var selectedView: ViewKind = .home
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            TabView(selection: self.$selectedView) {
                HomeView(store: Main.store.home)
                    .tag(ViewKind.home)
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }

                ControlView(store: Main.store.control)
                    .tag(ViewKind.control)
                    .tabItem {
                        Image(systemName: "gamecontroller")
                        Text("Control")
                    }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(store: Main.store)
    }
}
