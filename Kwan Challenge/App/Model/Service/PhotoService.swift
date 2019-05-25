//
//  PhotoService.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 25/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import Foundation

protocol PhotoServiceRef {
    typealias GetPhotoServiceHandler = (ResultCustomService<PhotoModel.ResponsePhotoModel, CustomErrorService>) -> Void
    
    func get(by model: PhotoModel.RequestPhotoModel, handler: @escaping GetPhotoServiceHandler)
}

class PhotoService: BaseService, PhotoServiceRef {
    func get(by model: PhotoModel.RequestPhotoModel, handler: @escaping PhotoService.GetPhotoServiceHandler) {
        
    }
}
