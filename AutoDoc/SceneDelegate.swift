//
//  SceneDelegate.swift
//  AutoDoc
//
//  Created by Dolphin on 20.08.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let newsViewModel = NewsViewModel()
        let newsController = NewsController(with: newsViewModel)
        window.rootViewController = UINavigationController(rootViewController: newsController)
        window.makeKeyAndVisible()
        self.window = window
    }

}
