//
//  PhotoManager.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 24/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import Foundation
import os.log

class SearchPhotoManager: BaseManager {
    
    let service: SearchPhotoServiceRef
    init(service: SearchPhotoServiceRef = SearchPhotoService() ) {
        self.service = service
    }
    
    func fetchDatas(page: Int = 1, completing: @escaping (_ success: SearchPhotosModel?, _ error:String?) -> Void) {
        
        var photoModel = SearchPhotosModel()
        let pageString = String(describing: page)
        photoModel.requestSearchPhotoModel = SearchPhotosModel.RequestSearchPhotoModel(apiKey: API.Info.key, page: pageString)
        
        self.service.photoSearch(photoModel: photoModel) { [weak self] (resultCustom) in            
            DispatchQueue.main.async {
                switch resultCustom {
                case .success(let responseModel):
                    photoModel.responseSearchPhotoModel = responseModel
                    completing(photoModel, nil)
                case .error(let errorCustom):
                    completing(nil, self?.errorToUser(errorCustom))
                }
            }
        }
        
    }
    
}
