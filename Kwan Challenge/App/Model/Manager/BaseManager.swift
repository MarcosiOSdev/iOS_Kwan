//
//  BaseManager.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 24/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import Foundation

/// performUI is for Test
/// DispatchQueue.main.async(execute: closure) stop all over Unit Test
/// performUI doen't stop the Unit Tests.
func performUIUpdate(using closure: @escaping () -> Void) {
    // If we are already on the main thread, execute the closure directly
    if Thread.isMainThread {
        closure()
    } else {
        DispatchQueue.main.async(execute: closure)
    }
}

class BaseManager{
    
    /**
     
     Create a error for user. Error About connection.
     
     - Parameters:
        - error: Error from Service that will be dealt with.
     
     - Returns: The message for user.
     */
    func errorToUser(_ error: CustomErrorService) -> String {
        switch error {
        case .conectionApi:
            return "Verify your conection."
        case .formatterJson:
            return "There are some change in API, please. Call to support."
        case .invalidRequest:
            return "Opss... Configuration wrong. Call to support."
        case .unexpected:
            return "Oops! Something went wrong!\nHelp us improve your experience by sending an error report"
        case .noData:
            return ""
        }
        
    }
}
