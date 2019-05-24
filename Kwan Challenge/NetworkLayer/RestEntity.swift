//
//  RestEntity.swift
//  participante
//
//  Created by Marcos Felipe Souza on 26/04/19.
//  Copyright © 2019 ISP. All rights reserved.
//

import Foundation

import Foundation

struct RestEntity {
    private var values: [String: String] = [:]
    
    mutating func add(value: String, forKey key: String) {
        values[key] = value
    }
    
    func value(forKey key: String) -> String? {
        return values[key]
    }
    
    func allValues() -> [String: String] {
        return values
    }
    
    func totalItems() -> Int {
        return values.count
    }
}

struct RestEntityBody {
    private var values: [String: Any] = [:]
    
    mutating func add(value: Any, forKey key: String) {
        values[key] = value
    }
    
    func value(forKey key: String) -> Any? {
        return values[key]
    }
    
    func allValues() -> [String: Any] {
        return values
    }
    
    func totalItems() -> Int {
        return values.count
    }
}
