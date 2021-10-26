//
//  SceneDelegate.swift
//  Hyperion
//
//  Created by Hack, Thomas on 13.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import HyperionApi
import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var store: Store<Main.State, Main.Action> = Main.store

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        let mainView = MainView(store: store)

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: mainView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {
        connect()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        disconnect()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        ViewStore(store).send(.openURLContexts(URLContexts))
    }

    private func connect() {
        let viewStore = ViewStore(store)
        guard let host = viewStore.state.shared.host, !host.isEmpty,
              let websocketUrl = URL(string: "ws://\(host)") else { return }
        viewStore.send(.api(.connect(websocketUrl)))
    }

    private func disconnect() {
        ViewStore(store).send(.api(.disconnect))
    }
}
