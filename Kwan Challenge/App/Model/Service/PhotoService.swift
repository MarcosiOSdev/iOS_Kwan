//
//  PhotoService.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 25/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import Foundation

protocol PhotoServiceRef: AnyObject {
    typealias GetPhotoServiceHandler = (ResultCustomService<PhotoModel.ResponsePhotoModel, CustomErrorService>) -> Void
    
    func get(by model: PhotoModel.RequestPhotoModel, handler: @escaping GetPhotoServiceHandler)
}

class PhotoService: BaseService, PhotoServiceRef {
    
    /**
     This method get photoSearch in an API.
     - Parameters:
        - by: This a method that need for Request.
        - handler: This is a return of callback, return the Response Model
     */
    func get(by model: PhotoModel.RequestPhotoModel,
             handler: @escaping PhotoService.GetPhotoServiceHandler) {
        let restAPI = RestApi()
        restAPI.urlQueryParameters = model.queryParameters()
        restAPI.makeRequest(toURL: url,
                            withHttpMethod: .get,
                            qos: .userInteractive) { results in
                                
                                if let data = results.data {
                                    guard let responseModel = try? JSONDecoder().decode(PhotoModel.ResponsePhotoModel.self, from: data) else {
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
