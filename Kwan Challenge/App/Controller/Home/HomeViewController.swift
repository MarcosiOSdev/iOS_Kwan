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
    
    @IBOutlet weak var collectionView: PhotosCollectionView! {
        didSet {
            self.collectionView.photoDelegate = self
        }
    }
    
    var searchPhotoManager = SearchPhotoManager()
    var searchView: SearchView?
    
    //When run viewDidAppear always when this view appears
    var isRunning: Bool = false
    
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
        self.handleSate = isRunning ? .none : .searchPhoto
    }
}

//MARK: - Handle State from HomeViewController are Presentation Logic
extension HomeViewController {
    enum HandleState {        
        case searchPhoto
        case successFetchSearchPhoto(SearchView)
        case performCollectionView
        case nextPage(Int)
        case showImage(PhotoModel.PhotoView)
        case error(String)
        case none
    }
    
    func performHandleState() {
        switch self.handleSate {
        case .searchPhoto:
            isRunning = true
            settingError(nil)
            fetchSearchPhoto()
            
        case .successFetchSearchPhoto(let searchView):
            self.searchView = searchView
            self.handleSate = .performCollectionView
            
        case .performCollectionView:
            self.photosDataSourceReload()
            
        case .nextPage(let page):
            fetchSearchPhoto(page: page)
            
        case .showImage(let modelView):
            imageOnFullscreen(modelView)
            
        case .error(let errorString):
            settingError(errorString)
            
        default:
            break
        }
    }
}

//MARK: - InfinityScroll get nextPage
extension HomeViewController: PhotosCollectionDelegate {
    func didTap(on photoView: PhotoModel.PhotoView) {
        self.handleSate = .showImage(photoView)
    }
    
    func nextPage(_ page: Int) {
        self.handleSate = .nextPage(page)
    }
}


//MARK: -- Fechtings , Use always API.
extension HomeViewController {
    
    func fetchSearchPhoto(page: Int? = nil) {
        self.searchPhotoManager.fetchDatas(page: page) { [weak self] (modelView) in
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
    
    func imageOnFullscreen(_ photoView: PhotoModel.PhotoView) {
        let fullScreen = FullScreenImageViewController.loadFromNib()
        fullScreen.urlString = photoView.sourceLarge
        
        //PopUp 
        self.addChild(fullScreen)
        fullScreen.view.frame = self.view.frame
        self.view.addSubview(fullScreen.view)
        fullScreen.didMove(toParent: self)
        

//        self.present(fullScreen, animated: true)
    }
}

