//
//  HeroesViewModelMapper.swift
//  Marvel-Navigator
//
//  Created by Nicolas Yuste on 18/07/2020.
//  Copyright © 2020 Nicoyuste Inc. All rights reserved.
//

import Foundation

/// Interactor used to load Comics from Marvel API
class ComicsInteractor: MarvelInteractor {
    
    init(datasource: MarvelDatasource) {
        super.init(resourcePath: "/v1/public/series", apiFilteringKey: "titleStartsWith", datasource: datasource)
    }
    
    /// Override method
    override func viewModelsFromAPIResponse(response: MarvelDataResponse) -> [MarvelListViewModel]? {
        guard let data = response.jsonDic["data"] as? [String: Any], let jsonObjects = data["results"] as? [[String: Any]] else {
            return []
        }
        
        var objects: [MarvelListViewModel] = []
        for object in jsonObjects {
            guard let id = object["id"] as? Int,
                  let title = object["title"] as? String,
                  let imageInfo = object["thumbnail"] as? [String: String] else { continue }
            
            var imageUrl: String?
            if let imagePath = imageInfo["path"], let imageExtension = imageInfo["extension"] {
                if !imagePath.contains("image_not_available") {
                    imageUrl = imagePath + "." + imageExtension
                }
            }
            
            let newViewModel = MarvelListViewModel(id: String(id), name: title, description: object["description"] as? String, imageUrl: imageUrl)
            objects.append(newViewModel)
        }
        return objects
    }
}
