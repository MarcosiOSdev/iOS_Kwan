//
//  PhotosCollectionViewTests.swift
//  Kwan ChallengeTests
//
//  Created by Marcos Felipe Souza on 26/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import XCTest
@testable import Kwan_Challenge

class PhotosCollectionViewTests: XCTestCase {

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

}
