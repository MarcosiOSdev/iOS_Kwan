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
            self.imageView.loadImage(by: id, withSource: source)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.borderWidth = 1.0
        
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.contentView.layer.cornerRadius).cgPath
        
        self.layoutSubviews()
    }

}
