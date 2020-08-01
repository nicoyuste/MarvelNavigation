//
//  MarvelPresenter.swift
//  Marvel-Navigator
//
//  Created by Nicolas Yuste on 01/08/2020.
//  Copyright © 2020 Nicoyuste Inc. All rights reserved.
//

import Foundation
import UIKit
import SwiftIcons

private enum controllerMode {
    case normal
    case filtered
}


/// Presenter of the VIPER architecture
class MarvelPresenter {
    
    // MARK: Initial config
    // All this initial config is added using the convenience init methods in the subclasses of this presenter
    
    /// The image that will be used in the header of the tableView
    let headerImageName: String
    
    /// The background color for the viewController, this will be in sync with the top header image
    let backgroundColor: UIColor
    
    /// The title that needs to be loaded, this basically used for a Navigation Controller or the Tab Controller
    let title: String
    
    /// The icon that is going to be displayed on the tabBar Controller for this specific config
    let icon: IoniconsType
    
    /// TableView class that needs to be used
    let tableViewCellToDisplay: String
    
    /// This interactor will handle the API calls and data coversion to viewModels
    let interactor: MarvelInteractor
    
    /// This is the application router, each presenter will call here whenever they want to move a different screen
    let router: MarvelNavigatorRouter
    
    // TODO: This should be a protocol so we can have any view used by this presenter
    var view: MarvelListViewController?
    
    // MARK: State
    
    private var mode: controllerMode = .normal
    private var filteredViewModels: [MarvelListViewModel] = []
    private var normalViewModels: [MarvelListViewModel] = []
    private var viewModels: [MarvelListViewModel] {
        get {
            switch mode {
                case .normal: return normalViewModels
                case .filtered: return filteredViewModels
            }
        }
    }
    private var totalViewModels = 0
    private var query: String? = nil

    // MARK: - Init methods
    
    init(title: String, iconName: IoniconsType, headerImageName: String, backgroundColor: UIColor, cellToDisplay: String, interactor: MarvelInteractor, router: MarvelNavigatorRouter) {
        self.title = title
        self.icon = iconName
        self.backgroundColor = backgroundColor
        self.headerImageName = headerImageName
        self.tableViewCellToDisplay = cellToDisplay
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: View Notifications to this presenter
    
    /// The view will call here when it is going to be presented.
    /// This way, our VIPER presenter can do whatever we need to do to init the view
    func viewWillAppear() {
        if viewModels.count <= 0 {
            view?.showLoading()
            viewNeedsViewModels(offset: 0, query: nil)
        }
    }
    
    /// The view will notify the presenter here when an item is loaded into the tableView (or whatever view structure, the presenter doesn't care)
    /// - Parameter index: This will be the index the view just loaded into the view
    func loadedElementIntoTableView(index: Int) {
        if index == viewModels.count - 3 && totalViewModels > viewModels.count {
            viewNeedsViewModels(offset: viewModels.count - 1, query: query)
        }
    }
    
    /// The view will notify here the presenter when the user typed a new query into the search box
    /// - Parameter newQuery: This will be the new query the user wants to search for
    func userEnteredNewQueryInSearchBar(newQuery: String) {
        if newQuery.count >= 3 {
            filteredViewModels = []
            view?.showLoading()
            view?.reloadData(viewModels: viewModels)
            viewNeedsViewModels(offset: 0, query: newQuery)
        }
    }
    
    /// The view will notify here the presenter when the user wants to see the details page of a given Marvel resource
    /// - Parameter index: This will be the indext of the element the user clicked
    func userWantsToEnterDetailsPageForIndex(index: Int) {
        router.showMarvelDetails(detailsViewModel: viewModels[index])
    }
    
    /// The view will notify here the presenter whenever the user wants to enter the search mode
    @objc func userWantsToEnterSearchMode() {
        mode = .filtered
        
        view?.reloadData(viewModels: viewModels)
        view?.enterSearchMode()
    }
    
    /// The view will notify here the presenter whenever the user wants to close the search mode
    @objc func userWantsToCloseSearchMode() {
        mode = .normal
        query = nil
        filteredViewModels = []
        
        view?.reloadData(viewModels: viewModels)
        view?.closeSearchMode()
    }
    
    // MARK: Private Helpers
    
    /// Private method internal to the presenter.
    /// It is used to talked with the interactor and load any marvel resource
    /// - Parameters:
    ///   - offset: The ofsset for the API call
    ///   - query: In case the user is in search mode, this will be the query entered in the search box
    private func viewNeedsViewModels(offset: Int, query: String?) {
        
        interactor.getMarvelViewModels(offset: offset, limit: 20, query: query).done { (viewModels, totalCount) in
            self.totalViewModels = totalCount
            switch self.mode {
            case .normal: self.normalViewModels.append(contentsOf: viewModels)
            case .filtered: self.filteredViewModels.append(contentsOf: viewModels)
            }
            self.view?.removeLoading()
            self.view?.reloadData(viewModels: self.viewModels)
            
        }.catch { error in
            // TODO: Handle error, probably an alert view that lets the user retry.
            print(error.localizedDescription)
        }
        
    }
    
}
