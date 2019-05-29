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
    
    init(imageService: ImageServiceRef = ImageService()) {
        super.init()
        self.imageService = imageService
    }
    
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
