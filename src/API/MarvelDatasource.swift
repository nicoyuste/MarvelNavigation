//
//  MarvelDatasource.swift
//  Marvel-Navigator
//
//  Created by Nicolas Yuste on 17/07/2020.
//  Copyright © 2020 Nicoyuste Inc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftHash
import PromiseKit

class MarvelDatasource {
    
    // MARK: API static definitions
    private let PUBLIC_KEY = "c89ae99f9d32f213de36ea890ee718cc"
    private let PRIVATE_KEY = "174cf34cc2c0429bc79f6721bc8f9b95a96b74a4"
    private let MARVEL_HOST = "gateway.marvel.com"
    private let HTTP = "https"
    
    /// Calls to Marvel API and returns one marvel resource
    /// - Parameters:
    ///   - path: The path for the resource we want to load from Marvel API
    ///   - offset: Default: 0 -> The offset for the array of elements in the resource. 0 will return the first element, X will return the element at possition X in the whole array of elements
    ///   - limit: Default: 20 -> The maximun number of elements we want to get back after the offset
    ///   - query: Optional query, if present, API will return filtered elements based on that query
    func getMarvelResource(path: String, offset: Int = 0, limit: Int = 20, query: String?, filterBy: String?) -> Promise<MarvelDataResponse> {
        
        let timestamp = String(Int(NSDate().timeIntervalSince1970))
        let hash = MD5(timestamp + PRIVATE_KEY + PUBLIC_KEY).lowercased()
        
        var urlParams = [
            "apikey": PUBLIC_KEY,
            "hash": hash,
            "ts": timestamp,
            "offset": String(offset),
            "limit": String(limit),
        ]
        
        if let query = query, let filterBy = filterBy { urlParams[filterBy] = query }

        let requestUrl = HTTP + "://" + MARVEL_HOST + path
        
        return Promise { seal in
            AF.request(requestUrl, method: .get, parameters: urlParams)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let json):
                        guard let dictionary = json as? [String: Any] else {
                            seal.reject( MarvelError(errorCode: 500, errorMessage: nil) )
                            return
                        }
                        seal.fulfill(MarvelDataResponse(jsonDic: dictionary))
                    case .failure(let error):
                        seal.reject(error)
                    }
            }
        }
    }
}
