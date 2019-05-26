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
    
    var photoModel = SearchPhotosModel()
    let service: SearchPhotoServiceRef
    init(service: SearchPhotoServiceRef = SearchPhotoService() ) {
        self.service = service
    }
    
    func fetchDatas(page: Int = 1, completing: @escaping (_ success: SearchPhotosModel.SearchPhotosView) -> Void) {
        
        
        let pageString = String(describing: page)
        photoModel.requestSearchPhotoModel = SearchPhotosModel.RequestSearchPhotoModel(apiKey: API.Info.key, page: pageString)
        
        self.service.photoSearch(requestModel: photoModel.requestSearchPhotoModel!) { [weak self] (resultCustom) in            
            DispatchQueue.main.async {
                guard let weakSelf = self else { return }
                
                switch resultCustom {
                case .success(let responseModel):
                    weakSelf.photoModel.responseSearchPhotoModel = responseModel
                    weakSelf.photoModel.prepareView(by: responseModel)
                    
                case .error(let errorCustom):
                    weakSelf.photoModel.prepareView(by: weakSelf.errorToUser(errorCustom))
                    
                }
                completing(weakSelf.photoModel.searchPhotoView!)
            }
        }
        
    }
    
}
