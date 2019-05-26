//
//  SearchPhotoServiceStub.swift
//  Kwan ChallengeTests
//
//  Created by Marcos Felipe Souza on 25/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import Foundation
@testable import Kwan_Challenge

class SearchPhotoServiceStub: SearchPhotoServiceRef {
    
    var mockSuccess:Bool
    
    init(mockSuccess: Bool) {
        self.mockSuccess = mockSuccess
    }
    
    func photoSearch(requestModel: SearchPhotosModel.RequestSearchPhotoModel, completeHandle handler: @escaping SearchPhotoServiceStub.CompleteHandlePhotoSearch) {
        
        
        if mockSuccess {
            
            if requestModel.page == "1" {
                let photos = [SearchPhotosModel.Photo(id: "1"),
                              SearchPhotosModel.Photo(id: "2"),
                              SearchPhotosModel.Photo(id: "3"),
                              SearchPhotosModel.Photo(id: "4"),
                              SearchPhotosModel.Photo(id: "5"),
                              SearchPhotosModel.Photo(id: "6"),
                              SearchPhotosModel.Photo(id: "7"),
                              SearchPhotosModel.Photo(id: "8"),
                ]
                let photo = SearchPhotosModel.Photos(page: 1, pages: 1000, photo: photos)
                let response = SearchPhotosModel.ResponseSearchPhotoModel(photos: photo, stat: "")
                handler(.success(response))
            
            }
            if requestModel.page == "2" {
                let photos = [SearchPhotosModel.Photo(id: "1")]
                let photo = SearchPhotosModel.Photos(page: 1, pages: 1000, photo: photos)
                let response = SearchPhotosModel.ResponseSearchPhotoModel(photos: photo, stat: "")
                handler(.success(response))
            }
            
        
        } else {
            handler(.error(.unexpected))
        }
        
        
    }
    
    
}
