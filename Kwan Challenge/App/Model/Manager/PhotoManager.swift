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
    
    func getPhoto(photoId: String, completeHandle handler: @escaping (_ model: PhotoModel.PhotoView)-> Void) {
        
        model.requestPhotoModel = PhotoModel.RequestPhotoModel(apiKey: API.Info.key, photoId: photoId)
        
        self.photoService.get(by: model.requestPhotoModel! ) { [weak self](resultCustom) in
            
            performUIUpdate {
                guard let weakSelf = self else {
                    return
                }
                switch resultCustom {
                case .success(let success):
                    weakSelf.model.responsePhotoModel = success
                    weakSelf.model.performView(by: success)
                case .error(let error):
                    weakSelf.model.performView(by: weakSelf.errorToUser(error))
                }
                handler( weakSelf.model.photoView!)
            }
        }
    }
    
}
