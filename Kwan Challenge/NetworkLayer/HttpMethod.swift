//
//  HttpMethod.swift
//  participante
//
//  Created by Marcos Felipe Souza on 26/04/19.
//  Copyright © 2019 ISP. All rights reserved.
//

import Foundation

enum HttpMethod {
    case get
    case post(TypeHttpPostMethod)
    case put
    case patch
    case delete
}

extension HttpMethod: RawRepresentable {
    public typealias RawValue = String    
    /// Failable Initalizer
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "GET":  self = .get
        case "POST": self = .post(.json)
        case "PUT": self = .put
        case "PATCH": self = .patch
        case "DELETE": self = .delete
        default:
            return nil
        }
    }
    
    public var rawValue: RawValue {
        switch self {
        case .get:    return "GET"
        case .post:   return "POST"
        case .put:  return "PUT"
        case .patch: return "PATCH"
        case .delete: return "DELETE"
        }
    }
    
}

enum TypeHttpPostMethod: String {
    case json = "application/json"
    case xWwwFormUrlencoded = "application/x-www-form-urlencoded"
}
