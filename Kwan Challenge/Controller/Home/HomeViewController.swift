//
//  HomeViewController.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 23/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var searchPhotoManager = SearchPhotoManager()
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var heightConstrintErrorLabel: NSLayoutConstraint!
    
    var errorMessage: String? {
        didSet {
            if let errorMessage = errorMessage {
                
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
        self.searchPhotoManager.fetchDatas { [weak self] (_, error) in
            if let error = error {
                self?.errorMessage = error
            }            
        }
    }
}


extension HomeViewController {
    
}
