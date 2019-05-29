//
//  FullScreenImageViewController.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 27/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import UIKit
import SVProgressHUD

class FullScreenImageViewController: UIViewController {

    @IBOutlet weak var contentScrollView: UIScrollView! {
        didSet {
            self.contentScrollView.delegate = self
            let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapGesture(_:)))
            doubleTapGesture.numberOfTapsRequired = 2
            self.contentScrollView.addGestureRecognizer(doubleTapGesture)
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    var urlString: String?
    var imageManager: ImageManager = ImageManager()
    var state: HandleState? {
        didSet {
            performStateHandle()
        }
    }
    /// zoomInOut, when is true means that default zoom 1
    var normalZoom: Bool = true
}

//MARK: - StateHandle PresentationLogic
extension FullScreenImageViewController {
    
    /// Enum of State of View
    public enum HandleState {
        
        /// config every views and scrolls
        case setupViews
        
        /// get image in API
        case fetchingImage
        
        /// state in peace, state is normal
        case normal
        
        /// enum1 Description
        /// - gesture: gesture of Pan
        case panGesture(UIPanGestureRecognizer)
        
        /// get event double tap
        case doubleTapOnScrollView
        
        /// Dimiss View
        case closingModal
    }
    
    private func performStateHandle() {
        switch self.state! {
        case .setupViews:
            self.loading()
            
        case .fetchingImage:
            setupImageView()
            
        case .panGesture(let gesture):
            self.panGesture(gesture)
            
        case .doubleTapOnScrollView:
            self.normalZoom ? self.zoom2x() : self.resetZoom()
            self.normalZoom = !self.normalZoom
            
        case .closingModal:
            self.dismiss()
            
        case .normal:
            break
        }
    }
    
}

//MARK: - Lifecycle ViewController
extension FullScreenImageViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.state = .setupViews
    }
}

//MARK: - Others Functions
extension FullScreenImageViewController {
    
    private func loading() {
        SVProgressHUD.show()
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizer(_:)))
        self.view.addGestureRecognizer(panGesture)
        
        self.state = .fetchingImage
    }
    
    private func setupImageView() {
        guard let urlString = self.urlString else { return }        
        self.imageManager.get(by: urlString) { [weak self] (data, error) in
            performUIUpdate {
                if let data = data {
                    self?.imageView.image = UIImage(data: data)
                }
                SVProgressHUD.dismiss()
                self?.state = .normal
            }
        }
    }
    private func panGesture(_ gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: self.view)
        view.frame.origin = translation
        
        if gesture.state == .ended {
            let velocity = gesture.velocity(in: self.view)
            
            let totalY = UIScreen.main.bounds.height
            let limit = (totalY / 2) - 96
            
            if velocity.y >= 800 || limit < translation.y {
                self.state = .closingModal
            } else {
                UIView.animate(withDuration: 0.4) {
                    self.view.frame.origin = CGPoint(x: 0, y: 0)
                }
            }
        }
    }
    private func zoom2x() {
        self.contentScrollView.setZoomScale(2, animated: true)        
        self.state = .normal
    }
    private func resetZoom() {
        self.contentScrollView.setZoomScale(1, animated: true)
        self.contentScrollView.setContentOffset(.zero, animated: true)
        self.state = .normal
    }
    private func dismiss() {
        SVProgressHUD.dismiss()
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        self.view.removeFromSuperview()
        self.view = nil
    }
}

// Actions and Events
extension FullScreenImageViewController {
    
    // Swipe Down and Dismiss
    @objc func panGestureRecognizer(_ gesture: UIPanGestureRecognizer) {
        self.state = .panGesture(gesture)
    }
    // Reset the image and scrollview , removing zoom
    @objc func doubleTapGesture(_ gesture: UITapGestureRecognizer) {
        self.state = .doubleTapOnScrollView
    }
    // Dismiss button
    @IBAction func didTapCloseButton(_ sender: UIButton?) {
        self.state = .closingModal
    }
}


extension FullScreenImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
