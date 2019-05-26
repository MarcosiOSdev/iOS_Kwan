//
//  PhotoServiceStub.swift
//  Kwan ChallengeTests
//
//  Created by Marcos Felipe Souza on 26/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import Foundation
@testable import Kwan_Challenge

class PhotoServiceStub:BaseServiceStub, PhotoServiceRef {
    
    override init(fakeError: CustomErrorService? = nil) {
        super.init(fakeError: fakeError)
    }
    
    func get(by model: PhotoModel.RequestPhotoModel, handler: @escaping PhotoServiceStub.GetPhotoServiceHandler) {
        
        if self.mockSuccess {
            self.mockSuccessFunc(model, handler)
        } else {
            self.mockFailFunc(handler)
        }
    }
    
    private func mockSuccessFunc(_ model: PhotoModel.RequestPhotoModel, _ handler: @escaping PhotoServiceStub.GetPhotoServiceHandler) {
        
        let _ = API.Info.key //Just Covarage the API.Info
        
        
        
    }
    
    private func mockFailFunc(_ handler: @escaping PhotoServiceStub.GetPhotoServiceHandler) {
        handler(.error(self.fakeError ?? .unexpected))
    }
}
