//
//  HeroesViewModelMapper.swift
//  Marvel-Navigator
//
//  Created by Nicolas Yuste on 18/07/2020.
//  Copyright © 2020 Nicoyuste Inc. All rights reserved.
//

import Foundation

/// This class is able to convert from a Characters API response to our view MarvelListViewModel
class CharactersViewModelMapper: ViewModelMapper {
    
    // MARK: ViewModelMapper protocol implementation
    
    func viewModelsFromAPIResponse(response: MarvelDataResponse) -> [MarvelListViewModel] {
        guard let data = response.jsonDic["data"] as? [String: Any], let jsonObjects = data["results"] as? [[String: Any]] else {
            return []
        }
        
        var objects: [MarvelListViewModel] = []
        for object in jsonObjects {
            guard let id = object["id"] as? Int,
                  let name = object["name"] as? String,
                  let imageInfo = object["thumbnail"] as? [String: String] else { continue }
            
            var imageUrl: String?
            if let imagePath = imageInfo["path"], let imageExtension = imageInfo["extension"] {
                imageUrl = imagePath + imageExtension
            }
            
            let newViewModel = MarvelListViewModel(id: String(id), name: name, description: object["description"] as? String, imageUrl: imageUrl)
            objects.append(newViewModel)
        }
        return objects
    }
}
