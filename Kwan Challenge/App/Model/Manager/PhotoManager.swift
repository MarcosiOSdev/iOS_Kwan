//
//  PhotoManager.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 25/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import Foundation

class PhotoManager: BaseManager {
    
    let photoService: PhotoServiceRef
    var model = PhotoModel()
    
    init(photoService: PhotoServiceRef = PhotoService()) {
        self.photoService = photoService
    }
    
    func getPhoto(photoId: String, completeHandle handler: @escaping (_ model: PhotoModel.PhotoView?, _ error: String? )-> Void) {
        
        model.requestPhotoModel = PhotoModel.RequestPhotoModel(apiKey: API.Info.key, photoId: photoId)
        
        self.photoService.get(by: model.requestPhotoModel! ) { [weak self](resultCustom) in
            switch resultCustom {
            case .success(let success):
                self?.model.responsePhotoModel = success
                self?.model.performView(by: success)
                handler(self?.model.photoView, nil)
            case .error(let error):
                handler(nil, self?.errorToUser(error))
                
            }
        }
    }
    
}
