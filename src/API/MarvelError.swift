//
//  MarvelError.swift
//  Marvel-Navigator
//
//  Created by Nicolas Yuste on 18/07/2020.
//  Copyright © 2020 Nicoyuste Inc. All rights reserved.
//

import Foundation

/// API representation of an error
struct MarvelError: Error {
    
    let errorCode: Int!
    let errorMessage: String!
    
    init(errorCode: Int, errorMessage: String?) {
        self.errorCode = errorCode
        self.errorMessage = errorMessage ?? "There was a problem, please try again"
    }
    
    var localizedDescription: String { return errorMessage }
}
