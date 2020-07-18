//
//  MarvelDataResponse.swift
//  Marvel-Navigator
//
//  Created by Nicolas Yuste on 18/07/2020.
//  Copyright © 2020 Nicoyuste Inc. All rights reserved.
//

import Foundation

/// Representation of Marvel API response. It hold the important data from the marvel API
struct MarvelDataResponse {
    
    /// Raw json object returned by the API
    let jsonDic: [String: Any]!
    
    init(jsonDic: [String: Any]) {
        self.jsonDic = jsonDic
    }
}
