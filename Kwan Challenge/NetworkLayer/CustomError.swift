//
//  ErrorManager.swift
//  participante
//
//  Created by Marcos Felipe Souza on 26/04/19.
//  Copyright © 2019 ISP. All rights reserved.
//

import Foundation

enum CustomError: Error {
    case failedToCreateRequest
}
extension CustomError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .failedToCreateRequest: return NSLocalizedString("Unable to create the URLRequest object", comment: "")
        }
    }
}
