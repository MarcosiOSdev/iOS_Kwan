//
//  FullScreenImageViewController.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 27/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import UIKit
import SVProgressHUD

class FullScreenImageViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var contentScrollView: UIScrollView! {
        didSet {
            self.contentScrollView.delegate = self
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        setupImageView()
        SVProgressHUD.show(with: .black)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizer(_:)))
        self.view.addGestureRecognizer(panGesture)
    }
    
    @objc func panGestureRecognizer(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        view.frame.origin = translation
        
        if gesture.state == .ended {
            let velocity = gesture.velocity(in: self.view)
            
            let totalY = UIScreen.main.bounds.height
            let limit = (totalY / 2) - 96
            
            if velocity.y >= 800 || limit < translation.y {
                self.didTapCloseButton(nil)
            } else {
                UIView.animate(withDuration: 0.4) {
                    self.view.frame.origin = CGPoint(x: 0, y: 0)
                }
            }
        }
        
    }
    
    func setupImageView() {
        
        guard let urlString = self.urlString,
            let url = URL(string: urlString) else { return }
        
        DispatchQueue.global(qos: .background).async {
            if let dataImage = try? Data(contentsOf: url) {
                performUIUpdate {
                    self.imageView.image = UIImage(data: dataImage)
                    SVProgressHUD.dismiss()
                }
            }
        }
    }

    @IBAction func didTapCloseButton(_ sender: UIButton?) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        self.view.removeFromSuperview()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
