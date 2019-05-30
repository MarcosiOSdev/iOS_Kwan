//
//  PhotoModel.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 25/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import Foundation

struct PhotoModel {
    
    var photoView: PhotoView?
    var responsePhotoModel: ResponsePhotoModel?
    var requestPhotoModel: RequestPhotoModel?
    
    mutating func performView(by responseModel: ResponsePhotoModel) {
        
        let largeSquareSize = responseModel.sizes.size.filter { $0.label == "Large Square" }.first
        let largeSize = responseModel.sizes.size.filter { $0.label == "Large"}.first
        
        self.photoView = PhotoView(id: requestPhotoModel?.photoId,
                                   sourceLarge: largeSize?.source,
                                   sourceSquare: largeSquareSize?.source,
                                   errorMessage: nil)
    }
    mutating func performView(by error: String) {
        self.photoView = PhotoView(id: nil,
                                   sourceLarge: nil,
                                   sourceSquare: nil,
                                   errorMessage: error)
    }
}

//MARK: Just show in the view.
extension PhotoModel {
    struct PhotoView {
        var id:String?
        var sourceLarge: String?
        var sourceSquare: String?
        var errorMessage: String?
    }
}

//MARK: - Model for Request in GET flickr.photos.getSizes
extension PhotoModel {
    struct RequestPhotoModel {
        let apiKey: String
        var photoId: String
        
        //default values
        let format: String = "json"
        let nojsoncallback: String = "1"
        let method: MethodEnumModel = .getSizes
        
        func queryParameters() -> RestEntity {
            var query = RestEntity()
            query.add(value: method.rawValue, forKey: "method")
            query.add(value: apiKey, forKey: "api_key")
            query.add(value: photoId, forKey: "photo_id")
            query.add(value: format, forKey: "format")
            query.add(value: nojsoncallback, forKey: "nojsoncallback")
            return query
        }
    }
}

//MARK: - Response of GET flickr.photos.getSizes
extension PhotoModel {
    struct ResponsePhotoModel: Codable {
        let sizes: Sizes
    }
    
    // MARK: - Sizes
    struct Sizes: Codable {
        let size: [Size]
    }
    
    // MARK: - Size
    struct Size: Codable {
        let label: String
        let source: String
    }
}
