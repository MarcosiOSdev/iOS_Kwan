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
    
    func testViewController() {
        
        //When init HomeViewController
            // -- Collection view is empty.
        XCTAssertNil(self.vc.collectionView.photoIds)
        
            // -- And ViewController is not nill.
        XCTAssertNotNil(self.vc)
    }
    
    func testInitingViewController(){
        
        //- When Start ViewController
        self.vc.viewDidAppear(false)
        
            // -- Should Have Presentation State is performCollectionView , call the photos..
        XCTAssertEqual(self.vc.handleSate, .performCollectionView)
        
            // -- Should Have Error Label is Hidden
        XCTAssertTrue(self.vc.errorLabel.isHidden)
        
            // -- And Should Have Model Request in Manager has page 1
        XCTAssertEqual(self.manager.photoModel.requestSearchPhotoModel?.page, "1")
        
            // -- And Should Have  Model Response in Manager has the same photoIds count in ViewModel
        XCTAssertEqual(self.manager.photoModel.responseSearchPhotoModel?.photos.photo.count, self.manager.photoModel.searchPhotoView?.photoIds.count )
        
            // --And  Should Have Manager and ViewController have the same ViewModel
        XCTAssertEqual(self.manager.photoModel.searchPhotoView, self.vc.searchView)
        
        // -- And Should Have Model Response in Manager has the same photoIds count in ViewModel in ViewController
        XCTAssertEqual(self.manager.photoModel.responseSearchPhotoModel?.photos.photo.count, self.vc.searchView?.photoIds.count )
        
    }
    
    func testInitingViewControllerWithUnexpectedError() {
        self.manager = SearchPhotoManager(service: SearchPhotoServiceStub(fakeError: .unexpected))
        self.vc.searchPhotoManager = self.manager
        
        // When Start ViewController with Error
        self.vc.viewDidAppear(false)
        
        // -- Should Have Handle State is Error
        XCTAssertEqual(self.vc.handleSate, .error("Oops! Something went wrong!\nHelp us improve your experience by sending an error report"))
        
        // -- Should Have Error Label is opened
        XCTAssertFalse(self.vc.errorLabel.isHidden)
        
        // -- Should Have view Model like nill
        XCTAssertNil(self.vc.searchView)
        
        //Animation in Error Label and Constraint from 0 to 50
        let cancelExpectation = expectation(description: "Animation in ErrorLabel")
        cancelExpectation.isInverted = true
        waitForExpectations(timeout: 4.0, handler: nil)
        
        // --Should Have Model Response in Manager has the same text error in Label in ViewController
        XCTAssertEqual(self.manager.photoModel.searchPhotoView?.errorMessage, self.vc.errorLabel.text)   
    }
    
    
    //MARK: -- MANAGER ERROR
    
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
    }
}
