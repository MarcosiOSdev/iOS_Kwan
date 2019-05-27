//
//  HomeViewController.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 23/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import UIKit

//Mark: Variables
class HomeViewController: UIViewController {
    typealias SearchView = SearchPhotosModel.SearchPhotosView
    typealias PhotoView = PhotoModel.PhotoView
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var heightConstrintErrorLabel: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: PhotosCollectionView!
    
    var searchPhotoManager = SearchPhotoManager()
    var searchView: SearchView?
    
    var handleSate: HandleState = .none {
        didSet {
            performHandleState()
        }
    }

}

//MARK: - LifeCycle ViewController
extension HomeViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.handleSate = .searchPhoto
    }
}

//MARK: - Handle State from HomeViewController are Presentation Logic
extension HomeViewController {
    enum HandleState {        
        case searchPhoto
        case successFetchSearchPhoto(SearchView)
        case performCollectionView
        case error(String)
        case none
    }
    
    func performHandleState() {
        switch self.handleSate {
        case .searchPhoto:
            settingError(nil)
            fetchSearchPhoto()
            
        case .successFetchSearchPhoto(let searchView):
            self.searchView = searchView
            self.handleSate = .performCollectionView
            
        case .performCollectionView:
            self.photosDataSourceReload()
            
        case .error(let errorString):
            settingError(errorString)
            
        default:
            break
        }
    }
}


//MARK: -- Fechtings , Use always API.
extension HomeViewController {
    
    func fetchSearchPhoto() {
        self.searchPhotoManager.fetchDatas { [weak self] (modelView) in
            if let error = modelView.errorMessage {
                self?.handleSate = .error(error)
            } else {
                self?.handleSate = .successFetchSearchPhoto(modelView)
            }            
        }
    }
}

//MARK: - Others Functions
extension HomeViewController {
    func settingError(_ errorString: String?) {
        if let errorMessage = errorString {            
            self.heightConstrintErrorLabel.constant = 50
            UIView.animate(withDuration: 1.5, animations: {
                self.loadViewIfNeeded()
                self.errorLabel.isHidden = false
            }) { completed in
                
                UIView.transition(with: self.errorLabel,
                                  duration: 1.5,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    self.errorLabel.text = errorMessage
                })
            }
            
        } else {
            errorLabel.text = ""
            heightConstrintErrorLabel.constant = 0
            errorLabel.isHidden = true
        }
    }
    
    func photosDataSourceReload() {
        if let searchView = self.searchView {
            self.collectionView.searchPhotoView = searchView
        } 
    }
}
