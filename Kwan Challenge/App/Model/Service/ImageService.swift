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
