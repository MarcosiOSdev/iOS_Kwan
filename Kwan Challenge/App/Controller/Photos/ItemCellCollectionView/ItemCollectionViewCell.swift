//
//  ItemCollectionViewCell.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 25/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: LoaderImageView!
    
    static let reuseCell = "itemCollectionViewCell"
    static var nib: UINib {
        return UINib(nibName: String(describing: ItemCollectionViewCell.self), bundle: nil)
    }
    
    
    var photoView: PhotoModel.PhotoView? {
        didSet{
            guard let photoView = self.photoView,
            let id = photoView.id,
            let source = photoView.sourceSquare else {
                self.imageView.image = nil
                return
            }
            self.imageView.loadImage(by: id, withSource: source) { completed in
                if completed {
                    if let _  = self.imageView.image {
                        self.imageView.isShimmering = false
                    }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Default image
        self.imageView.image = UIImage(named:"image-default")
        
        //Loading image
        self.imageView.isShimmering = true
        
        //Round image
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 10
    }
    
}
