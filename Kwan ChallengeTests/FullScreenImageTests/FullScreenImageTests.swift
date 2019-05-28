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


}
