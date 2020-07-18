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
    
    /// Pagination information so we know how more data is left in the backend side
    let totalCount: Int!
    
    init(jsonDic: [String: Any]) {
        self.jsonDic = jsonDic
        guard let data = jsonDic["data"] as? [String: Any] else {
            totalCount = 0
            return
        }
        totalCount = data["total"] as? Int ?? 0
    }
}
