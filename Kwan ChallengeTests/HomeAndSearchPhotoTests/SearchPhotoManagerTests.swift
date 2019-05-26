//
//  SearchPhotoManager.swift
//  Kwan ChallengeTests
//
//  Created by Marcos Felipe Souza on 26/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//


import Foundation

import XCTest
@testable import Kwan_Challenge

class SearchPhotoManagerTests: XCTestCase {

    var serviceStub: SearchPhotoServiceRef!
    var manager: SearchPhotoManager!
    var vc: HomeViewController!
    
    override func setUp() {
        self.vc = HomeViewController.loadFromNib()
        _ = self.vc.view //Start viewDidLoad
        self.serviceStub = SearchPhotoServiceStub()
        self.manager = SearchPhotoManager(service: self.serviceStub)
        self.vc.searchPhotoManager = self.manager
    }
    
    override func tearDown() {
        serviceStub = nil
        manager = nil
        vc = nil
    }
    
    
    func testManagerWithFailConnection() {
        
        //Create a Fail Connect API and Inject Dependency
        self.manager = SearchPhotoManager(service: SearchPhotoServiceStub(fakeError: .conectionApi))
        
        //When Manager with Fail Connection
        self.manager.fetchDatas(page: 1) { (viewModel) in
            
            // -- Its ViewModel has error
            XCTAssertNotNil(self.manager.photoModel.searchPhotoView?.errorMessage)
            
            // -- Error is like "Verify your conection."
            XCTAssertEqual(self.manager.photoModel.searchPhotoView?.errorMessage, "Verify your conection.")
        }
    }
    
    func testManagerWithFailFormatterJson() {
        
        //Create a Fail Connect API and Inject Dependency
        self.manager = SearchPhotoManager(service: SearchPhotoServiceStub(fakeError: .formatterJson))
        
        //When Manager with Fail Connection
        self.manager.fetchDatas(page: 1) { (viewModel) in
            
            // -- Its ViewModel has error
            XCTAssertNotNil(self.manager.photoModel.searchPhotoView?.errorMessage)
            
            // -- Error is like "There are some change in API, please. Call to support."
            XCTAssertEqual(self.manager.photoModel.searchPhotoView?.errorMessage, "There are some change in API, please. Call to support.")
        }
    }
    
    
    
    func testFecthPage() {
        
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
        
        manager.fetchDatas(page: 2) { viewModel in
            //Same Page
            XCTAssertEqual(viewModel.page, 2)
            
            //Same Count of Photos
            XCTAssertEqual(viewModel.photoIds, self.manager.photoModel.searchPhotoView?.photoIds)
            
            // In page 2 has 1 fotos
            XCTAssertEqual(viewModel.photoIds.count, 1)
            
            //In page 1 first item has id = 1 and the last one has id = 9
            XCTAssertEqual(viewModel.photoIds.first, "9")
            XCTAssertEqual(viewModel.photoIds.last, "9")
            
            //There no error
            XCTAssertNil(viewModel.errorMessage)
        }
    }


}
