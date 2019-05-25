//
//  CustomErrorService.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 24/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import Foundation


enum ResultCustomService<Success, Error> {
    case success(Success)
    case error(Error)
}

enum CustomErrorService: Error {
    case formatterJson
    case conectionApi
    case invalidRequest
    case unexpected
}
