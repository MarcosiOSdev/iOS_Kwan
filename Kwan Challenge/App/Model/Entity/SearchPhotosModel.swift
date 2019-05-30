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
    
    mutating func prepareView(by responseModel: ResponseSearchPhotoModel) {
        var model = SearchPhotosView()
        
        if let request = self.requestSearchPhotoModel,
            let pageInt = Int(request.page) {
            model.page = pageInt
        }
        
        model.totalPage = responseModel.photos.pages
        model.photosPerPage = responseModel.photos.perpage
        model.photoIds = responseModel.photos.photo.map {$0.id}
        self.searchPhotoView = model
    }
    
    mutating func prepareView(by error: String) {
        var model = SearchPhotosView()
        model.errorMessage = error
        self.searchPhotoView = model
    }
    
}


//MARK: - Model for View
extension SearchPhotosModel {
    struct SearchPhotosView {
        var page: Int = 0
        var photoIds: [String] = []
        var errorMessage: String?
        
        var totalPage:Int = 0
        var photosPerPage:Int = 0
    }
}


//MARK: - Request Model for GET flickr.photos.search
extension SearchPhotosModel {
    struct RequestSearchPhotoModel {
        let apiKey: String
        let page: String
        
        //default values
        let tags: String = "kitten"
        let format: String = "json"
        let nojsoncallback: String = "1"
        let method: MethodEnumModel = .photoSearch
        
        
        func queryParameters() -> RestEntity {            
            var queryParametter = RestEntity()
            queryParametter.add(value: self.method.rawValue, forKey: "method")
            queryParametter.add(value: self.apiKey, forKey: "api_key")
            queryParametter.add(value: self.tags, forKey: "tags")
            queryParametter.add(value: self.page, forKey: "page")
            queryParametter.add(value: self.format, forKey: "format")
            queryParametter.add(value: self.nojsoncallback, forKey: "nojsoncallback")
            return queryParametter
        }
    }
}


//MARK: - Response Model for GET flickr.photos.search
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
        
        init(photos: Photos, stat:String) {
            self.photos = photos
            self.stat = stat
        }
    }
    
    // MARK: - Photos
    struct Photos: Codable {
        let page, pages, perpage: Int
        let photo: [Photo]
        
        init(page: Int, pages:Int, perpage:Int, photo: [Photo]) {
            self.page = page
            self.pages = pages
            self.photo = photo
            self.perpage = perpage
        }
    }
    
    // MARK: - Photo
    struct Photo: Codable {
        let id: String
        init(id: String) {
            self.id = id
        }
    }

}
