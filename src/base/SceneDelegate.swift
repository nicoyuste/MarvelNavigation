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

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let window = window else { return }
        
        // Creating the datasource here. This datasource is going to be injected into the viewController.
        // Other coding pattern is for this MarvelDatasource to a be singleton and having the viewController directly without passing it in the init method.
        // The problem with that approach is unit testing. Unit tests for singletons and with singletons is a nightmare.
        // This way, from the unit test, I can inject any datasource and mock any data I want.
        // TODO: We could create a protocol for datasources, that way, it is even easier to pass different datasources into the viewController.
        let source = MarvelDatasource()
        
        // Lets create all the configurations we want to load in our application
        // TODO: This could be moved to a Config Factory Class
        let marvelConfigs = [
            
            MarvelConfig(title: "Heroes", // The title the list View Controller is going to be using
                         iconName: .iosPeopleOutline, // The icon the list view controller will have in the tabBar
                         headerImageName: "heroes", // Name of the image that will be loaded in header of the tableView
                         backgroundColor: UIColor(red: 0.561, green: 0.753, blue: 0.976, alpha: 1), // Background color for the list viewController
                         resourcePath: "/v1/public/characters", // Resource the viewController will load from the API using the injected datasource
                         mapper: CharactersViewModelMapper(), // Mapper the viewController will use to convert API responses into viewModels
                         cellToDisplay: "CharacterListTableViewCell", // Name of the cell the viewController will use to display results
                         apiFilteringKey: "nameStartsWith" ), // query filter for the API
            
            MarvelConfig(title: "Series",
                         iconName: .iosBrowsersOutline,
                         headerImageName: "series",
                         backgroundColor: .black,
                         resourcePath: "/v1/public/series",
                         mapper: ComicsViewModelMapper(),
                         cellToDisplay: "SeriesListTableViewCell",
                         apiFilteringKey: "titleStartsWith"),
            
            MarvelConfig(title: "Comics",
                         iconName: .iosBookOutline,
                         headerImageName: "comics",
                         backgroundColor: .white,
                         resourcePath: "/v1/public/comics",
                         mapper: ComicsViewModelMapper(),
                         cellToDisplay: "ComicListTableViewCell",
                         apiFilteringKey: "titleStartsWith")
        ]
        
        // Create the tab bar with all the childs and push it into the Stack
        guard let tabBarController = window.rootViewController as? UITabBarController else { return }
        for config in marvelConfigs {
            let newHvc = MarvelListViewController(config: config, marvelDataSource: source)
            let navigationController = UINavigationController(rootViewController: newHvc)
            navigationController.tabBarItem.image = UIImage(icon: .ionicons(config.icon), size: CGSize(width: 40,height: 40))
            navigationController.title = config.title
            tabBarController.addChild(navigationController)
        }
    }
}

