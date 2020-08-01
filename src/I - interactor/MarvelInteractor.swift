//
//  ViewModelMapper.swift
//  Marvel-Navigator
//
//  Created by Nicolas Yuste on 18/07/2020.
//  Copyright © 2020 Nicoyuste Inc. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire
import SwiftHash

/// This Base Interactor hold most of the logic regarding Marvel APIs.
/// This interactor cannot be instanciated and you will need to use one of the interactors inheriting from it.
/// If not, this will fail when creating the viewModels.
class MarvelInteractor {
    
    /// This is the Marvel resource path sho we can get our information from the API
    let resourcePath: String
    
    /// If the user is searching, we need to filter using this key in the API
    let apiFilteringKey: String
    
    /// This is the API client used by this interactor.
    /// It will abstract the fact that we use Alamofire from the interactor
    let datasource: MarvelDatasource

    init(resourcePath: String, apiFilteringKey: String, datasource: MarvelDatasource) {
        self.resourcePath = resourcePath
        self.apiFilteringKey = apiFilteringKey
        self.datasource = datasource
    }
    
    convenience init() {
        fatalError("Base Marvel Interactor cannot be used on it's own. You need to create an instance of a childs who overrides this method")
    }
    
    /// Calls to Marvel API and returns one marvel resource.
    /// Presenters will use this method from the interactors.
    /// - Parameters:
    ///   - path: The path for the resource we want to load from Marvel API
    ///   - offset: Default: 0 -> The offset for the array of elements in the resource. 0 will return the first element, X will return the element at possition X in the whole array of elements
    ///   - limit: Default: 20 -> The maximun number of elements we want to get back after the offset
    ///   - query: Optional query, if present, API will return filtered elements based on that query
    func getMarvelViewModels(offset: Int, limit: Int, query: String?) -> Promise<([MarvelListViewModel], Int)> {
        
        return datasource.getMarvelResource(path: resourcePath, offset: offset, limit: limit, query: query, filterBy: apiFilteringKey)
            .then { (response) -> Promise<([MarvelListViewModel], Int)> in
            return Promise { seal in
                guard let viewModels = self.viewModelsFromAPIResponse(response: response) else {
                    seal.reject(MarvelError(errorCode: 500, errorMessage: "Failed to load data from the network"))
                    return
                }
                seal.fulfill((viewModels, response.totalCount))
            }
        }
    }

    
    /// Internal method every interactor will have to override it.
    /// This method will convert any Marvel API response into an array of viewModels our presenters and View understands
    /// - Parameter response: A list of Marvel View Models
    func viewModelsFromAPIResponse(response: MarvelDataResponse) -> [MarvelListViewModel]? {
        fatalError("Base Marvel Interactor cannot be used on it's own. You need to create an instance of a childs who overrides this method")
    }
    
}
