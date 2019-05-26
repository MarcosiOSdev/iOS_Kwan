//
//  PhotoService.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 24/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import Foundation
import os.log

protocol SearchPhotoServiceRef: AnyObject {
    typealias CompleteHandlePhotoSearch = (_ responseResult: ResultCustomService<SearchPhotosModel.ResponseSearchPhotoModel, CustomErrorService>) -> Void
    
    func photoSearch(requestModel: SearchPhotosModel.RequestSearchPhotoModel, completeHandle handler: @escaping CompleteHandlePhotoSearch)
}

class SearchPhotoService: BaseService, SearchPhotoServiceRef {
    
    func photoSearch(requestModel: SearchPhotosModel.RequestSearchPhotoModel, completeHandle handler: @escaping SearchPhotoService.CompleteHandlePhotoSearch) {
        
        let restApi = RestApi()
        restApi.urlQueryParameters = requestModel.queryParameters()
        
        restApi.makeRequest(toURL: url,
                            withHttpMethod: .get,
                            qos: .userInitiated) { results in
            
            if let data = results.data {               
                guard let responseModel = SearchPhotosModel.ResponseSearchPhotoModel(with: data) else {
                    handler(.error(.formatterJson))
                    return
                }                
                handler(.success(responseModel))
            }
            if let error = results.error {
                handler(.error(self.verifyError(error)))
            }
            
        }
        
    }
    
    
}
