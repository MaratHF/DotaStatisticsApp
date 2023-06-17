//
//  SceneDelegate.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 06.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let presenter = FavoritePlayersPresenter(favoritePlayers: [])
        let favoritePlayersVC = FavoritePlayersViewController(presenter: presenter)
        let navigationVC = UINavigationController(rootViewController: favoritePlayersVC)
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationVC
        window.makeKeyAndVisible()
        self.window = window
    }
}

