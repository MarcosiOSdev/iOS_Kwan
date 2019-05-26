//
//  HomeViewControllerTest.swift
//  Kwan ChallengeTests
//
//  Created by Marcos Felipe Souza on 26/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//
import Foundation

import XCTest
@testable import Kwan_Challenge

class HomeViewControllerTests: XCTestCase {

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
        // -- Then Collection view is empty.
        XCTAssertNil(self.vc.collectionView.photoIds)
        
        // -- And ViewController is not nill.
        XCTAssertNotNil(self.vc)
        
        // Then ViewController (VC) is init
        self.vc.viewDidAppear(false)
        
        // -- Should have Presentation State is performCollectionView , call the photos..
        XCTAssertEqual(self.vc.handleSate, .performCollectionView)
        
        // To Be continue in .. testInitingViewController()
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
    
    private func testInitInvalidViewController(error: CustomErrorService, expectedMessage: String ){
        self.manager = SearchPhotoManager(service: SearchPhotoServiceStub(fakeError: error))
        self.vc.searchPhotoManager = self.manager
        
        // When Start ViewController with Error
        self.vc.viewDidAppear(false)
        
        // -- Should Have Handle State is Error.
        XCTAssertEqual(self.vc.handleSate, .error(expectedMessage))
        
        // -- Should Have Error Label is opened.
        XCTAssertFalse(self.vc.errorLabel.isHidden)
        
        // -- Should Have view Model like nill.
        XCTAssertNil(self.vc.searchView)
        
        //Animation in Error Label and Constraint from 0 to 50.
        let cancelExpectation = expectation(description: "Animation in ErrorLabel")
        cancelExpectation.isInverted = true
        waitForExpectations(timeout: 3.0, handler: nil)
        
        // --Should Have Error Label like this message.
        XCTAssertEqual(self.vc.errorLabel.text, expectedMessage)
        
        // --Should Have Model Response in Manager has the same text error in Label in ViewController.
        XCTAssertEqual(self.manager.photoModel.searchPhotoView?.errorMessage, self.vc.errorLabel.text)
    }
    
    func testInitingViewControllerWithUnexpectedError() {
        self.testInitInvalidViewController(error: .unexpected, expectedMessage: "Oops! Something went wrong!\nHelp us improve your experience by sending an error report")
    }
    
    func testInitingViewControllerWithInvalidRequest() {
        self.testInitInvalidViewController(error: .invalidRequest, expectedMessage: "Opss... Configuration wrong. Call to support.")
    }
    
    func testInitingViewControllerWithFormatterJsonError() {
        self.testInitInvalidViewController(error: .formatterJson, expectedMessage: "There are some change in API, please. Call to support.")
    }
    
    func testInitingViewControllerWithConectionApiError() {
        self.testInitInvalidViewController(error: .conectionApi, expectedMessage: "Verify your conection.")
    }

    
}
