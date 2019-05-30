//
//  PhotoManager.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 24/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import Foundation

/// Class has Bussines logic, translate with ViewModel with ResponseModel and RequestModel.
/// RequestModel is using in all Request for API and
/// ResponseModel is using in all Response from API.
class SearchPhotoManager: BaseManager {
    
    var photoModel = SearchPhotosModel()
    let service: SearchPhotoServiceRef
    
    /// Initialization With Dependency Injection,
    /// It's the most used in Unit Test for mocks
    init(service: SearchPhotoServiceRef = SearchPhotoService() ) {
        self.service = service
    }
    
    
    /**
     
     FetchDatas(page: completing:) get photos and photos with Id for next service.
     Need the pages and completing for work.
     
     - Parameters:
        - page: Page is default value equals 1, Case you set this parameter with nil, the page value will be 1. for example.
        - completing: There are result about this called for the API the of searchPhoto. Result is a SearchPhotoView
     
     */
    func fetchDatas(page: Int? = nil, completing: @escaping (_ success: SearchPhotosModel.SearchPhotosView) -> Void) {

        let pageInt = page ?? 1 // first page is always 1
        let pageString = String(describing: pageInt)
        photoModel.requestSearchPhotoModel =
            SearchPhotosModel.RequestSearchPhotoModel(apiKey: API.Info.key,
                                                      page: pageString)
        
        self.service.photoSearch(requestModel: photoModel.requestSearchPhotoModel!) { [weak self] (resultCustom) in            
            
            guard let weakSelf = self else { return }
            
            switch resultCustom {
            case .success(let responseModel):
                weakSelf.photoModel.responseSearchPhotoModel = responseModel
                weakSelf.photoModel.prepareView(by: responseModel)
                
            case .error(let errorCustom):
                weakSelf.photoModel.prepareView(by: weakSelf.errorToUser(errorCustom))
                
            }
            
            performUIUpdate {
                completing(weakSelf.photoModel.searchPhotoView!)
            }
        }
        
    }
    
}
