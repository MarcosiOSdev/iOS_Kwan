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

    
    //Search and Home -- Need because CollectionView is in the Home
    var searchPhotoServiceStub: SearchPhotoServiceRef!
    var searchPhotoManager: SearchPhotoManager!
    var homeViewController: HomeViewController!
    
    
    //Photo
    var photoServiceStub: PhotoServiceRef!
    var photoManager: PhotoManager!
    var photosCollectionView: PhotosCollectionView!
    
    
    
    override func setUp() {
        initHome()
        initPhoto()
    }
    
    override func tearDown() {
        searchPhotoServiceStub = nil
        searchPhotoManager = nil
        homeViewController = nil
        
        photoServiceStub = nil
        photoManager = nil
        photosCollectionView = nil
    }

    private func initHome() {
        self.homeViewController = HomeViewController.loadFromNib()
        _ = self.homeViewController.view //Start viewDidLoad
        self.searchPhotoServiceStub = SearchPhotoServiceStub()
        self.searchPhotoManager = SearchPhotoManager(service: searchPhotoServiceStub)
        self.homeViewController.searchPhotoManager = self.searchPhotoManager
    }
    
    private func initPhoto() {
        self.photosCollectionView = self.homeViewController.collectionView
        self.photoServiceStub = PhotoServiceStub()
        self.photoManager = PhotoManager(photoService: photoServiceStub)
        self.photosCollectionView.photoManager = photoManager
    }
    
    func testInitPhotoCollectionView() {
        
        // When Init Photo collection view
        // -- Should Handle in None
        XCTAssertEqual(photosCollectionView.handleState, .none)
        
        // -- Should have photo is empty
        XCTAssertNil(photosCollectionView.photoIds)
        
        // -- Should have cacheModel empty
        XCTAssertEqual(photosCollectionView.listModelCache.count, 0)
    }
    
    func testStartingPhotoCollectionView() {
        
        //Start PhotoCollectionView with photos
        photosCollectionView.photoIds = ["1", "2", "3"]
        
        // -- Then Change the state
        XCTAssertEqual(photosCollectionView.handleState, .performItem)
        
        // -- Then Photos ID is equals number of cache
        XCTAssertEqual(photosCollectionView.photoIds?.count, 3)
        
        //Animation in Error Label and Constraint from 0 to 50.
        let cancelExpectation = expectation(description: "Animation in ErrorLabel")
        cancelExpectation.isInverted = true
        waitForExpectations(timeout: 3.0, handler: nil)
        
        
        XCTAssertEqual(photosCollectionView.photoIds?.count, photosCollectionView.listModelCache.count)
    }
    
}
