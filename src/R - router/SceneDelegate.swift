//
//  SceneDelegate.swift
//  Marvel-Navigator
//
//  Created by Nicolas Yuste on 17/07/2020.
//  Copyright © 2020 Nicoyuste Inc. All rights reserved.
//

import UIKit
import SwiftIcons

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    var router: MarvelNavigatorRouter?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let window = window else { return }
        
        // Create the tab bar with all the childs and push it into the Stack
        guard let tabBarController = window.rootViewController as? UITabBarController else { return }
        router = MarvelNavigatorRouter(tabBarController: tabBarController)
        router?.setupInitialView()
    }
}

