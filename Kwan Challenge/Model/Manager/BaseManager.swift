//
//  BaseManager.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 24/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import Foundation

class BaseManager{
    
    /**
      Create a error for user.
        Error About connection.
     
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
        }
        
    }
}
