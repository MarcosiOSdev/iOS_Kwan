//
//  MethodEnumModel.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 24/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import Foundation

enum MethodEnumModel {
    case getSizes
    case photoSearch
}

extension MethodEnumModel: RawRepresentable {
    typealias RawValue = String
    
    /***
     Init not implementation
    */
    init?(rawValue: String) {
        fatalError("Method not implementation")
    }
    
    var rawValue: String {
        switch self {
        case .getSizes:
            return "flickr.photos.getSizes"
        case .photoSearch:
            return "flickr.photos.search"
        }
    }
}
