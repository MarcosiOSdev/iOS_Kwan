//
//  PhotosModel.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 24/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import Foundation

struct SearchPhotosModel {
    
    var requestSearchPhotoModel: RequestSearchPhotoModel?
    var responseSearchPhotoModel: ResponseSearchPhotoModel?
    var searchPhotoView: SearchPhotosView?
    
    mutating func prepareView() {
        var model = SearchPhotosView()
        
        if let request = self.requestSearchPhotoModel,
            let pageInt = Int(request.page) {
            model.page = pageInt
        }
        
        if let response = self.responseSearchPhotoModel {
            model.idPhotos = response.photos.photo.map {$0.id}
        }
        
        self.searchPhotoView = model
    }
    
    func queryParameters() -> RestEntity {
        
        guard let model = self.requestSearchPhotoModel else { return RestEntity()}
        var queryParametter = RestEntity()
        queryParametter.add(value: model.method.rawValue, forKey: "method")
        queryParametter.add(value: model.apiKey, forKey: "api_key")
        queryParametter.add(value: model.tags, forKey: "tags")
        queryParametter.add(value: model.page, forKey: "page")
        queryParametter.add(value: model.format, forKey: "format")
        queryParametter.add(value: model.nojsoncallback, forKey: "nojsoncallback")
        
        return queryParametter
    }
    
}


// Model for View
extension SearchPhotosModel {
    struct SearchPhotosView {
        var page: Int = 0
        var idPhotos: [String] = []
    }
}


// Request Model for GET flickr.photos.search
extension SearchPhotosModel {
    struct RequestSearchPhotoModel {
        let apiKey: String
        let page: String
        
        //default values
        let tags: String = "kitten"
        let format: String = "json"
        let nojsoncallback: String = "1"
        let method: MethodEnumModel = .photoSearch
    }
}


// Response Model for GET flickr.photos.search
extension SearchPhotosModel {
    struct ResponseSearchPhotoModel: Codable {
        let photos: Photos
        let stat: String
        
        init?(with data:Data) {
            guard let model = try? JSONDecoder().decode(ResponseSearchPhotoModel.self, from: data) else {
                return nil
            }
            self = model
        }
        
    }
    
    // MARK: - Photos
    struct Photos: Codable {
        let page, pages, perpage: Int
        let total: String
        let photo: [Photo]
    }
    
    // MARK: - Photo
    struct Photo: Codable {
        let id, owner, secret, server: String
        let farm: Int
        let title: String
        let ispublic, isfriend, isfamily: Int
    }

}
