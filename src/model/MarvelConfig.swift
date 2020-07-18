//
//  MavelConfig.swift
//  Marvel-Navigator
//
//  Created by Nicolas Yuste on 17/07/2020.
//  Copyright © 2020 Nicoyuste Inc. All rights reserved.
//

import Foundation
import UIKit

/// Our MarvelListViewController (our view) doesn't know what resource from the API is going to be loaded. It can display any type of resource
/// and everything what that controller needs is this configuration file. This will allow our controller to display characters, comics, authors, etc...
class MarvelConfig {
    
    /// The image that will be used in the header of the tableView
    let headerImageName: String!
    
    /// The background color for the viewController, this will be in sync with the top header image
    let backgroundColor: UIColor!
    
    /// The title that needs to be loaded, this basically used for a Navigation Controller or the Tab Controller
    let title: String!
    
    /// This is the Marvel resource path sho we can get our information from the API
    let resourcePath: String!
    
    /// This mapper will be responsible from converting the Marvel API response into a View Model the View Controller can understand
    /// ViewModelMapper is just an interface. We will have one specific class for each Marvel resource we want to support
    let viewModelMapper: ViewModelMapper!
    
    init(title: String, headerImageName: String, backgroundColor: UIColor, resourcePath: String, mapper: ViewModelMapper) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.headerImageName = headerImageName
        self.resourcePath = resourcePath
        self.viewModelMapper = mapper
    }
}
