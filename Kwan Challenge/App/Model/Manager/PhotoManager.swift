//
//  PhotoManager.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 25/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import Foundation

class PhotoManager: BaseManager {
    
    let photoService: PhotoServiceRef
    
    init(photoService: PhotoServiceRef = PhotoService()) {
        self.photoService = photoService
    }
    
    func listPhoto() {
        
    }
    
}
