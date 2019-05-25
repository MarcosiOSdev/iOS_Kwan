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
    
    private var searchPhotoManager = SearchPhotoManager()
    private var photoManager = PhotoManager()
    
    var photoView: PhotoView?
    var searchView: SearchView?
    
    var idPhotos:[Int]?
    
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
        case getIdsPhoto
        case successFetchSearchPhoto(SearchView)
        case successIdPhotos(PhotoView)
        case error(String)
        case none
    }
    
    func performHandleState() {
        switch self.handleSate {
        case .searchPhoto:
            settingError(nil)
            fetchSearchPhoto()
            
        case .getIdsPhoto:
            settingError(nil)
            fetchIdPhotos()
            
        case .successFetchSearchPhoto(let searchView):
            self.searchView = searchView
            
        case .successIdPhotos(let photoView):
            self.photoView = photoView
            
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
        self.searchPhotoManager.fetchDatas { [weak self] (success, error) in
            if let error = error {
                self?.handleSate = .error(error)
            }
            if let success = success {
                self?.handleSate = .successFetchSearchPhoto(success)
            }
        }
    }
    
    func fetchIdPhotos() {
        
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
}
