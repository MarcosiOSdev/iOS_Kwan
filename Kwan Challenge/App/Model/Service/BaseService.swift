//
//  BaseService.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 24/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import Foundation

class BaseService {
    
    func verifyError(_ error: Error) -> CustomErrorService {
        if let errorAPI = error as? CustomErrorAPI {
            switch errorAPI {
            case .failedToCreateRequest:
                return .invalidRequest
            }
        }
        return .unexpected
    }
}
