//
//  FullScreenImageTests.swift
//  Kwan ChallengeTests
//
//  Created by Marcos Felipe Souza on 28/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import XCTest
@testable import Kwan_Challenge

class FullScreenImageTests: XCTestCase {

    var fullScreenVC: FullScreenImageViewController!
    
    override func setUp() {
        fullScreenVC = FullScreenImageViewController.loadFromNib()
    }

    override func tearDown() {
        fullScreenVC = nil
    }

    func testInitViewController() {
        _ = self.fullScreenVC.view //ViewDidLoad
        
        //View init with urlString nil
        XCTAssertNil(self.fullScreenVC.urlString)
    }
    
    func testInitViewControllerWithImage() {
        let source = """
https://live.staticflickr.com/5800/31456463045_5a0af4ddc8_s.jpg
"""
        self.fullScreenVC.urlString = source
        
        _ = self.fullScreenVC.view //ViewDidLoad
        
        //View init with urlString nil
        XCTAssertNotNil(self.fullScreenVC.urlString)
        
        
        //Downloading Image.
        let cancelExpectation = expectation(description: "Downloading Image")
        cancelExpectation.isInverted = true
        waitForExpectations(timeout: 5.0, handler: nil)
        
        XCTAssertNotNil(self.fullScreenVC.imageView.image)
        
        // Tapped on Button X
        self.fullScreenVC.didTapCloseButton(UIButton())        
    }
    
    func testSetupStateFullScreenVC() {
        let source = """
https://live.staticflickr.com/5800/31456463045_5a0af4ddc8_s.jpg
"""
        self.fullScreenVC.urlString = source
        
        _ = self.fullScreenVC.view //ViewDidLoad
        
        // Init with fetching state
        XCTAssertNotNil(self.fullScreenVC.state)
        
        // SETUP VIEWS
        self.fullScreenVC.state = .setupViews
        
        //Downloading Image.
        let cancelExpectation = expectation(description: "Downloading Image")
        cancelExpectation.isInverted = true
        waitForExpectations(timeout: 5.0, handler: nil)
        
        //Then state is normal
        XCTAssertEqual(self.fullScreenVC.state, .normal)
        
    }
    
    func testZoomStateFullScreenVC() {
        
        _ = self.fullScreenVC.view //ViewDidLoad
        
        // SETUP VIEWS on double tap for zoom
        self.fullScreenVC.state = .doubleTapOnScrollView
        
        //Content ScrollView is 2 , Zoom in Image
        XCTAssertEqual(self.fullScreenVC.contentScrollView.zoomScale, 2.0)
        
        //THEN state is normal
        XCTAssertEqual(self.fullScreenVC.state, .normal)
        
        
        //Removing Zoom
        self.fullScreenVC.state = .doubleTapOnScrollView
        
        //Content ScrollView is 2 , Zoom in Image
        XCTAssertEqual(self.fullScreenVC.contentScrollView.zoomScale, 1.0)
        
        //And Center the image
        XCTAssertEqual(self.fullScreenVC.contentScrollView.contentOffset, CGPoint.zero)
        
        //THEN state is normal
        XCTAssertEqual(self.fullScreenVC.state, .normal)
        
    }
    
    func testClosingStateFullScreenVC() {
        
        _ = self.fullScreenVC.view //ViewDidLoad
        
        // SETUP VIEWS
        self.fullScreenVC.state = .closingModal
    }

}
