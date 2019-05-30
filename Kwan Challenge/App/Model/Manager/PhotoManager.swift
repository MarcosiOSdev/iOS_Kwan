//
//  PhotoManager.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 25/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import Foundation

/// Class has Bussines logic, translate with ViewModel with ResponseModel and RequestModel.
/// RequestModel is using in all Request for API and
/// ResponseModel is using in all Response from API.
class PhotoManager: BaseManager {
    
    let photoService: PhotoServiceRef
    var model = PhotoModel()
    
    /// Initialization With Dependency Injection,
    /// It's the most used in Unit Test for mocks
    init(photoService: PhotoServiceRef = PhotoService()) {
        self.photoService = photoService
    }
    
    /**
     Get photo , this is the second url for get some photo.
     
     - Parameters:
        - photoId: photoId is a string ID that have gotten in searchPhoto (first conection)
        - completeHandle: Its a handler with photoView value, photoView is the model for View (ControllerView or Colletion)
 
     */
    func getPhoto(photoId: String, completeHandle handler: @escaping (_ model: PhotoModel.PhotoView)-> Void) {
        self.model.requestPhotoModel = PhotoModel.RequestPhotoModel(apiKey: API.Info.key, photoId: photoId)
        
        self.photoService.get(by: model.requestPhotoModel! ) { [weak self](resultCustom) in
            performUIUpdate {
                if let weakSelf = self {                    
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
    
}
