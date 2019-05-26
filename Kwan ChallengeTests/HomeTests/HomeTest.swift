//
//  HomeTest.swift
//  Kwan ChallengeTests
//
//  Created by Marcos Felipe Souza on 25/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import Foundation

import XCTest
@testable import Kwan_Challenge

class HomeTest: XCTestCase {
   
    var serviceStub: SearchPhotoServiceRef!
    var manager: SearchPhotoManager!
    
    override func setUp() {        
        self.serviceStub = SearchPhotoServiceStub(mockSuccess: true)
        self.manager = SearchPhotoManager(service: self.serviceStub)
        
    }
    
    override func tearDown() {
        serviceStub = nil
        manager = nil
    }
    
    func testCheckSearchPhoto() {
        
        manager.fetchDatas(page: 1) { viewModel in
            //Same Page
            XCTAssertEqual(viewModel.page, 1)
            
            //Same Count of Photos
            XCTAssertEqual(viewModel.photoIds, self.manager.photoModel.searchPhotoView?.photoIds)
            
            // In page 1 has 8 fotos
            XCTAssertEqual(viewModel.photoIds.count, 8)
            
            //In page 1 first item has id = 1 and the last one has id = 8
            XCTAssertEqual(viewModel.photoIds.first, "1")
            XCTAssertEqual(viewModel.photoIds.last, "8")
            
            //There no error
            XCTAssertNil(viewModel.errorMessage)
        }
    }
}
