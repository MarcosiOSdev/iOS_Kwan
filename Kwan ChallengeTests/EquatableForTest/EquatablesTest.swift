//
//  EquatablesTest.swift
//  Kwan ChallengeTests
//
//  Created by Marcos Felipe Souza on 26/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import Foundation
@testable import Kwan_Challenge

/**
 JUST FOR UNIT TEST
 **/
extension HomeViewController.HandleState : Equatable {
    public static func == (lhs: HomeViewController.HandleState, rhs: HomeViewController.HandleState) -> Bool {
        switch (lhs, rhs) {
        case (.searchPhoto, .searchPhoto):
            return true
        case (.successFetchSearchPhoto(let lhsValue), .successFetchSearchPhoto(let rhsValue) ):
            return lhsValue.page == rhsValue.page && lhsValue.photoIds == rhsValue.photoIds
        case (.performCollectionView, .performCollectionView):
            return true
        case (.error(let lhsValue), .error(let rhsValue)):
            return lhsValue == rhsValue
        case (.none, .none):
            return true
        default:
            return false
        }
        
    }
}

extension PhotosCollectionView.HandleState : Equatable {
    public static func == (lhs: PhotosCollectionView.HandleState, rhs: PhotosCollectionView.HandleState) -> Bool {
        switch (lhs, rhs) {
        case (.performItem ,.performItem):
            return true
        case (.getMoreItem ,.getMoreItem):
            return true
        case (.tapOnCell(let lhsValue) ,.tapOnCell(let rhsValue)):            
            return lhsValue == rhsValue
        case (.none ,.none):
            return true
        default:
            return false
        }
    }
}

extension FullScreenImageViewController.HandleState : Equatable {
    public static func == (lhs: FullScreenImageViewController.HandleState, rhs: FullScreenImageViewController.HandleState) -> Bool {
        
        switch (lhs, rhs) {
        case (.setupViews, .setupViews):
            return true
        case (.fetchingImage, .fetchingImage):
            return true
        case (.normal, .normal):
            return true
        case (.resetScrollView, .resetScrollView):
            return true
        case (.closingModal, .closingModal):
            return true
        case (.panGesture(let lhsValue), .panGesture(let rhsValue)):
            return lhsValue == rhsValue
        default:
            return false
        }
    }
}


extension SearchPhotosModel.SearchPhotosView : Equatable {
    public static func == (lhs: SearchPhotosModel.SearchPhotosView, rhs: SearchPhotosModel.SearchPhotosView) -> Bool {
        
        return lhs.page == rhs.page &&
            lhs.photoIds.count == rhs.photoIds.count &&
            lhs.errorMessage == rhs.errorMessage
    }
}

