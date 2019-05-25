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
    
}





//MARK: Just show in the view.
extension PhotoModel {
    struct PhotoView {
        var sourceLarge: String?
        var sourceSquare: String?
    }
}


extension PhotoModel {
    struct RequestPhotoModel {
        let apiKey: String
        let photoId: String
        
        //default values
        let format: String = "json"
        let nojsoncallback: String = "1"
        let method: MethodEnumModel = .getSizes
    }
}

//MARK: - Response of GET flickr.photos.getSizes
extension PhotoModel {
    struct ResponsePhotoModel: Codable {
        let sizes: Sizes
        let stat: String
    }
    
    // MARK: - Sizes
    struct Sizes: Codable {
        let canblog, canprint, candownload: Int
        let size: [Size]
    }
    
    // MARK: - Size
    struct Size: Codable {
        let label: String
        let width, height: Height
        let source: String
        let url: String
        let media: Media
    }
    
    enum Height: Codable {
        case integer(Int)
        case string(String)
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let x = try? container.decode(Int.self) {
                self = .integer(x)
                return
            }
            if let x = try? container.decode(String.self) {
                self = .string(x)
                return
            }
            throw DecodingError.typeMismatch(Height.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Height"))
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .integer(let x):
                try container.encode(x)
            case .string(let x):
                try container.encode(x)
            }
        }
    }
    
    enum Media: String, Codable {
        case photo = "photo"
    }
}
