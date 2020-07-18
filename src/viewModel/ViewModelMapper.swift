//
//  ViewModelMapper.swift
//  Marvel-Navigator
//
//  Created by Nicolas Yuste on 18/07/2020.
//  Copyright © 2020 Nicoyuste Inc. All rights reserved.
//

import Foundation

/// Protocol all our View Model Mappers need to implement. It will allow our viewController to don't care about which Marvel resource we are trying to load
protocol ViewModelMapper {
    
    /// Takes one API response from Marvel and converts that into viewModels our View Stack can consume
    /// - Parameter response: an Array of view models which can be used on table or collection view.
    func viewModelsFromAPIResponse(response: MarvelDataResponse) -> [MarvelListViewModel]
}
