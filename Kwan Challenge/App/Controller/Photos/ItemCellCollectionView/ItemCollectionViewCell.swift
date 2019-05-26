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
            let source = photoView.sourceSquare else { return }
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
    }
    
}
