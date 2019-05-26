//
//  ErrorManager.swift
//  participante
//
//  Created by Marcos Felipe Souza on 26/04/19.
//  Copyright © 2019 ISP. All rights reserved.
//

import Foundation

enum CustomErrorAPI: Error {
    case failedToCreateRequest
    case timeOut
}
extension CustomErrorAPI: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .failedToCreateRequest:
            return NSLocalizedString("Unable to create the URLRequest object", comment: "")
        case .timeOut:
            return NSLocalizedString("Unable to internet", comment: "")
        }
    }
}
