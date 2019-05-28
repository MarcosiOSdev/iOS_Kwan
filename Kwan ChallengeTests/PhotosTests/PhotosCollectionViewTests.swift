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
        photosCollectionView.searchPhotoView = SearchPhotosModel.SearchPhotosView(page: 1,
                                                                                  photoIds: ["1", "2", "3"],
                                                                                  errorMessage: nil,
                                                                                  totalPage: 2,
                                                                                  photosPerPage: 3)
        
        // -- Then Change the state
        XCTAssertEqual(photosCollectionView.handleState, .performItem)
        
        // -- Then Photos ID is equals 3 , same numbers in photoIds
        XCTAssertEqual(photosCollectionView.photoIds?.count, 3)
        
        // -- And the same count
        XCTAssertEqual(photosCollectionView.photoIds?.count,
                       photosCollectionView.searchPhotoView?.photoIds.count)
        
        // -- And the same count in photos per page
        XCTAssertEqual(photosCollectionView.photoIds?.count,
                       photosCollectionView.searchPhotoView?.photosPerPage)
    }
    
    func testInfinityScrollPhotoCollectionView() {
        
        // Init HomeViewController (HomeVC), for get its manager and service Stub.
        self.homeViewController.viewDidAppear(false)
        
        // -- Then the first get 8 itens because of the MOCK
        // -- SearchPhotoServiceStub has 8 datas mock for page 1.
        
        XCTAssertEqual(self.searchPhotoManager.photoModel.responseSearchPhotoModel?.photos.photo.count, 8)
        
        // -- Then have the same count in ViewModel and the PerPhoto
        XCTAssertEqual(self.searchPhotoManager.photoModel.responseSearchPhotoModel?.photos.photo.count,
                       self.searchPhotoManager.photoModel.searchPhotoView?.photoIds.count)
        
        XCTAssertEqual(self.searchPhotoManager.photoModel.responseSearchPhotoModel?.photos.photo.count,
                       self.searchPhotoManager.photoModel.searchPhotoView?.photosPerPage)
        

        // -- Then Photos ID is equals 3 , same numbers in photoIds
        XCTAssertEqual(photosCollectionView.photoIds?.count, 8)
        
        // -- And the same count
        XCTAssertEqual(photosCollectionView.photoIds?.count,
                       photosCollectionView.searchPhotoView?.photoIds.count)
        
        // -- And the same count in photos per page
        XCTAssertEqual(photosCollectionView.photoIds?.count,
                       photosCollectionView.searchPhotoView?.photosPerPage)
        
        
        
        // ---- TEST InifityScroll HERE.
        self.photosCollectionView.handleState = .getMoreItem
        
        // -- Then manager change the page and send request
        XCTAssertEqual(self.searchPhotoManager.photoModel.requestSearchPhotoModel?.page, "2")
        
        // -- Then manager of searchPhoto get 1 photo with id 9 , remember because of mock in Stub (SearchServiceStub)
        XCTAssertEqual(self.searchPhotoManager.photoModel.responseSearchPhotoModel?.photos.photo.count, 1)
        XCTAssertEqual(self.searchPhotoManager.photoModel.responseSearchPhotoModel?.photos.photo.first?.id, "9")
        
        // -- Then PhotoCV should have 9 photos, 8 in page 1 and more 1 in page 2
        XCTAssertEqual(photosCollectionView.photoIds?.count, 9)
        
        // -- PhotoCV should have 9 in total item because 9 photoIds
        XCTAssertEqual(photosCollectionView.totalItem, 9)
        XCTAssertEqual(photosCollectionView.totalItem, photosCollectionView.photoIds?.count)
        
    }
    
    
    func testOpenPhoto() {
            
        // Init HomeViewController (HomeVC), for get its manager and service Stub.
        self.homeViewController.viewDidAppear(false)
    
        
        // -- when collection view start is handle in perform
        XCTAssertEqual(self.photosCollectionView.handleState, .performItem)
        
        // -- Then the first view is selected
        self.photosCollectionView.collectionView(self.photosCollectionView, didSelectItemAt: IndexPath(item: 1, section: 0))
        
        XCTAssertEqual(self.photosCollectionView.handleState, .tapOnCell(IndexPath(item: 1, section: 0)))
        
    }
}
