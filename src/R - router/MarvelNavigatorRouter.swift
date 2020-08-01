//
//  MarvelNavigatorRouter.swift
//  Marvel-Navigator
//
//  Created by Nicolas Yuste on 01/08/2020.
//  Copyright © 2020 Nicoyuste Inc. All rights reserved.
//

import UIKit

/// Router on the VIPER architecture
class MarvelNavigatorRouter: NSObject, UITabBarControllerDelegate {

    /// Initial controller of the application
    let tabBarController: UITabBarController
    
    // MARK: - Initialization
    
    /// Init method for the application router.
    /// The init method takes the tabBarController as a dependency because we are loading the application from an Storyboard
    /// Another possible solution is to don't use any story board and initialize the tabBarController here
    /// - Parameter tabBarController: The initial tabBarController
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    /// This method will setup the initial view stack and it will make sure all the presenters are in place
    func setupInitialView() {
        let datasource = MarvelDatasource()
        
        let presenters = [
            ComicsPresenter(interactor: ComicsInteractor(datasource: datasource), router: self),
            SeriesPresenter(interactor: SeriesInteractor(datasource: datasource), router: self),
            CharactersPresenter(interactor: CharactersInteractor(datasource: datasource), router: self)
        ]
        
        for presenter in presenters {
            let hvc = MarvelListViewController(presenter: presenter)
            presenter.view = hvc
            let nav = UINavigationController(rootViewController: hvc)
            nav.title = presenter.title
            nav.tabBarItem.image = UIImage(icon: .ionicons(presenter.icon), size: CGSize(width: 40,height: 40))
            tabBarController.addChild(nav)
        }
    }
    
    // MARK: - UI Navigation
    
    /// Method called by presenters
    /// It will navigate to the details page of any Marvel Resource
    /// - Parameter detailsViewModel: The details of the marvel resouce we want to load
    func showMarvelDetails(detailsViewModel: MarvelListViewModel) {
        guard let navController = tabBarController.viewControllers?[tabBarController.selectedIndex] as? UINavigationController else { return }
        let hvc = MarvelDetailsViewController.instantiate(with: detailsViewModel)
        navController.present(hvc, animated: true, completion: nil)
        
    }
    
    /// Any presenter can call this method so the router navigates back to the previous View
    func navigateBack() {
        guard let navController = tabBarController.viewControllers?[tabBarController.selectedIndex] as? UINavigationController else { return }
        navController.dismiss(animated: true)
    }
}
