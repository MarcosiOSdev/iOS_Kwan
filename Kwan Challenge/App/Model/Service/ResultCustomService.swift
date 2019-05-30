//
//  CustomErrorService.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 24/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import Foundation

/// A value that represents either a success or a failure, including an
/// associated value in each case.
enum ResultCustomService<Success, Error> {
    
    /// A success, storing a `Success` value.
    case success(Success)
    
    /// A failure, storing a `Failure` value.
    case error(Error)
}

/// A value that represents failures in Service Layer, including an
/// associated value in each case.
enum CustomErrorService: Error {
    
    /// There are not data in Response
    case noData
    
    /// Formatter JSON is wrong. Mapped wrong.
    case formatterJson
    
    /// There are no connection with API
    case conectionApi
    
    /// There are some thing wrong with Request
    case invalidRequest
    
    /// Untreated or unattached errors
    case unexpected
}
