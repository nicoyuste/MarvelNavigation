//
//  SceneDelegate.swift
//  Marvel-Navigator
//
//  Created by Nicolas Yuste on 17/07/2020.
//  Copyright © 2020 Nicoyuste Inc. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let window = window else { return }
        
        let source = MarvelDatasource()
        // Lets create all the configurations we want to load in our application
        // TODO: This could be moved to a Config Factory Class
        let marvelConfigs = [
            MarvelConfig(title: "Heroes",
                         headerImageName: "heroes",
                         backgroundColor: UIColor(red: 0.001, green: 0, blue: 0.001, alpha: 1),
                         resourcePath: "/v1/public/characters",
                         mapper: CharactersViewModelMapper())
        ]
        
        // Create the tab bar with all the childs and push it into the Stack
        guard let tabBarController = window.rootViewController as? UITabBarController else { return }
        for config in marvelConfigs {
            let newHvc = MarvelListViewController(config: config, marvelDataSource: source)
            let navigationController = UINavigationController(rootViewController: newHvc)
            navigationController.title = config.title
            tabBarController.addChild(navigationController)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

}

