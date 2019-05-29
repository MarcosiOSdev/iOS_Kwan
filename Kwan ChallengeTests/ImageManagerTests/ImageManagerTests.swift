//
//  ImageManagerTests.swift
//  Kwan ChallengeTests
//
//  Created by Marcos Felipe Souza on 29/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import XCTest
@testable import Kwan_Challenge

class ImageManagerTests: XCTestCase {

    var imageManager: ImageManager!
    var imageService: ImageServiceRef!
    
    override func setUp() {
        self.imageService = ImageServiceStub()
        self.imageManager = ImageManager(imageService: self.imageService)
    }

    override func tearDown() {
        self.imageService = nil
        self.imageManager = nil
    }

    func testGetImage() {
        
        // When test with success
        self.imageManager.get(by: "someURL") { (data, error) in
            
            // No erros.
            XCTAssertNil(error)
            
            // There is a data.
            XCTAssertNotNil(data)
            
            // Data is a image
            let image = UIImage(data: data!)
            XCTAssertNotNil(image)
        }
    }
    
    func testNoImage() {
        
        // When get image is failled
        self.imageService = ImageServiceStub(fakeError: .noData)
        self.imageManager.imageService = self.imageService
        
        self.imageManager.get(by: "someUrl") { (data, error) in
            // There is a erros.
            XCTAssertNotNil(error)
            
            // No data.
            XCTAssertNil(data)
            
            // Error is a empty string
            XCTAssertEqual(error!, "")

        }
        
    }

}
