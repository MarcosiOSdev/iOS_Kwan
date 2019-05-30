//
//  ImageManager.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 29/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import Foundation

class ImageManager: BaseManager {
    
    var imageService: ImageServiceRef!
    
    /// Initialization With Dependency Injection,
    /// It's the most used in Unit Test for mocks 
    init(imageService: ImageServiceRef = ImageService()) {
        super.init()
        self.imageService = imageService
    }
    
    /**
     
     Get Data by URL , using for get some photos or images
     
     - Parameters:
        - by: URL where you will get the image
        - completed: return is a completedHandler. This has a data and error in String.
     if there arent error, error will be true.
     */
    func get(by urlString: String, completed handler: @escaping (_ data: Data? , _ error: String? )->Void ) {
        
        guard let url = URL(string: urlString) else {
            handler(nil, self.errorToUser(.noData))
            return
        }
        imageService.get(by: url) { (results) in
            switch results {
            case .success(let data):
                handler(data, nil)
            case .error(let error):
                handler(nil, self.errorToUser(error))
            }
        }
    }
    
    
}
