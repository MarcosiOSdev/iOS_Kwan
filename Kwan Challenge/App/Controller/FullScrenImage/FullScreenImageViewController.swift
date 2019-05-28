//
//  FullScreenImageViewController.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 27/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import UIKit

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
    }
    
    func setupImageView() {
        
        guard let urlString = self.urlString,
            let url = URL(string: urlString) else { return }
        
        DispatchQueue.global(qos: .background).async {
            if let dataImage = try? Data(contentsOf: url) {
                performUIUpdate {
                    self.imageView.image = UIImage(data: dataImage)
                }
            }
        }
    }

    @IBAction func didTapCloseButton(_ sender: UIButton) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        self.dismiss(animated: true)
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
