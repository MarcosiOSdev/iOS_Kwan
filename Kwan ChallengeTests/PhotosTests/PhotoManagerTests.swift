//
//  PhotoManagerTests.swift
//  Kwan ChallengeTests
//
//  Created by Marcos Felipe Souza on 26/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import XCTest
@testable import Kwan_Challenge

class PhotoManagerTests: XCTestCase {

    var photoServiceStub: PhotoServiceRef!
    var photoManager: PhotoManager!
    
    
    override func setUp() {
        photoServiceStub = PhotoServiceStub()
        photoManager = PhotoManager(photoService: photoServiceStub)
    }

    override func tearDown() {
        photoManager = nil
        photoServiceStub = nil
    }

    func testGetPhotoId() {
        
        //PhotoManager get id photo 1
        self.photoManager.getPhoto(photoId: "1") { (photoView) in
            
            // -- Then PhotoView id is like the send
            XCTAssertEqual(photoView.id, "1")
            
            // -- Then PhotoView with large qnd square
            XCTAssertNotNil(photoView.sourceLarge)
            XCTAssertNotNil(photoView.sourceSquare)
            
            // -- Then PhotoView doesnt have error
            XCTAssertNil(photoView.errorMessage)
        }
    }
    
    func testErrorInService() {
        
        //PhotoManager get id photo 1 with service without conections
        self.photoServiceStub = PhotoServiceStub(fakeError: .conectionApi)
        photoManager = PhotoManager(photoService: photoServiceStub)
        
        photoManager.getPhoto(photoId: "1") { (photoView) in
            
            // -- Then doenst have url
            XCTAssertNil(photoView.sourceLarge)
            XCTAssertNil(photoView.sourceSquare)
            
            // -- And has error
            XCTAssertNotNil(photoView.errorMessage)
            
            // And Error is like
            XCTAssertEqual(photoView.errorMessage, "Verify your conection.")
        }
    }
}
