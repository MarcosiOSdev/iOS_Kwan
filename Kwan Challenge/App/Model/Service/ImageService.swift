//
//  ImageService.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 29/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import Foundation

protocol ImageServiceRef: AnyObject {
    func get(by url: URL, completed handler: @escaping(ResultCustomService<Data, CustomErrorService>) -> Void)
}

class ImageService: BaseService, ImageServiceRef {
    
    
    /**
     
     This method just do the get in an API
     - Parameters:
        -url: Type of URL for get the data
        -completed: This is a handle with ResultCustomService types Data and Error.
     */
    func get(by url: URL, completed handler: @escaping (ResultCustomService<Data, CustomErrorService>) -> Void) {
        RestApi().getData(fromURL: url) { data in
            if let data = data {
                handler(.success(data))
                return
            }
            handler(.error(.noData))
        }
    }
}
