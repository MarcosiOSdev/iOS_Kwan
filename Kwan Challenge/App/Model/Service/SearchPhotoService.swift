//
//  PhotoService.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 24/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import Foundation
import os.log

protocol SearchPhotoServiceRef {
    typealias CompleteHandlePhotoSearch = (_ responseResult: ResultCustomService<SearchPhotosModel.ResponseSearchPhotoModel, CustomErrorService>) -> Void
    
    func photoSearch(photoModel: SearchPhotosModel, completeHandle: @escaping CompleteHandlePhotoSearch)
}

class SearchPhotoService: BaseService, SearchPhotoServiceRef {
    
    func photoSearch(photoModel: SearchPhotosModel, completeHandle: @escaping SearchPhotoService.CompleteHandlePhotoSearch) {
        
        let restApi = RestApi()
        restApi.urlQueryParameters = photoModel.queryParameters()
        let url = API.Info.baseURL.replacingOccurrences(of: "\\", with: "")
        restApi.makeRequest(toURL: url, withHttpMethod: .get) { results in
            
            if let data = results.data {
                if #available(iOS 12.0, *) {
                    os_log(.default, log: .default, "Simple log with some %@.", String(data: data, encoding: .utf8) ?? "")
                } else {
                    
                }
                guard let responseModel = SearchPhotosModel.ResponseSearchPhotoModel(with: data) else {
                    completeHandle(.error(.formatterJson))
                    return
                }                
                completeHandle(.success(responseModel))
            }
            if let error = results.error {
                completeHandle(.error(self.verifyError(error)))
            }
            
        }
        
    }
    
    
}
