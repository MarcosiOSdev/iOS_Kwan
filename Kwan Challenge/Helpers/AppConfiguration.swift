//
//  AppConfiguration.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 23/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import Foundation

/// AppConfiguration can read Environment Information files (xcconfig).
struct AppConfiguration {
    
    /**
     Return value of key in Environment Information.
     
     - Parameters:
     - for: It's a key where you get the value.
     
     - Throws: If there is not the key in file You will got the "Invalid or missing Info.plist key:".
     
     - Returns: Return a value of called method type from `for` parameter.
     */
    static func value<T>(for key: String) -> T {
        guard let value = Bundle.main.infoDictionary?[key] as? T else {
            fatalError("Invalid or missing Info.plist key: \(key)")
        }
        
        return value
    }
}
