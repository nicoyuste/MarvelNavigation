//
//  MarvelListViewModel.swift
//  Marvel-Navigator
//
//  Created by Nicolas Yuste on 18/07/2020.
//  Copyright © 2020 Nicoyuste Inc. All rights reserved.
//

import Foundation

/// The viewModel used by the List View Controller.
/// This is the only peace of the data the View Controller understands and injected mappers will be used to convert API responses into viewModels.
///    You can see how this viewModels are created in MarvelListViewController.loadViewModels()
struct MarvelListViewModel {
    
    /// The name that will be used in the table view cell
    let name: String!
    
    /// The id for this specific resource, it can be used to get the deailts of this specific resource
    let id: String!
    
    /// An optional description that if present, will be displayed on the table view cell
    let description: String?
    
    /// An optional URL for an image that if present, will be displayed on the table view cell
    let imageUrl: String?
    
    init(id: String, name: String, description: String?, imageUrl: String?) {
        self.name = name
        self.id = id
        self.description = description
        self.imageUrl = imageUrl
    }
}
