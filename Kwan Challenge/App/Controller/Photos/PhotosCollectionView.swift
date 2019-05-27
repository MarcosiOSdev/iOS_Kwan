//
//  PhotosCollectionView.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 25/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import UIKit

class PhotosCollectionView: UICollectionView {
    
    var photoManager = PhotoManager()
    
    var photoIds: [String]? {
        didSet {
            if let photoIds = photoIds, photoIds.count > 0 {
                self.handleState = .performItem
            }
        }
    }
    
    var handleState: HandleState = .none {
        didSet {
            self.performHandleState()
        }
    }
    
    var listModelCache = [Int: PhotoModel.PhotoView]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initCustom()
    }
    
    func initCustom() {
        self.register(ItemCollectionViewCell.nib, forCellWithReuseIdentifier: ItemCollectionViewCell.reuseCell)
        self.delegate = self
        self.dataSource = self
    }
    
    
    //MARK: Vars for CollectionView
    var portraitScreenSize: CGSize?
    var landscapeScreenSize: CGSize?
    var isPortrate:Bool {
        return UIApplication.shared.statusBarOrientation.isPortrait
    }
    
    var sizeOfCellInPortrate: CGSize {
        let viewWidth = portraitScreenSize?.width ?? self.bounds.width
        let bordes = CGFloat(16) //8 leading + 8 trailling
        let bordesBetwenCell = CGFloat(16) //8 leading + 8 trailling
        let width = (viewWidth - bordes - bordesBetwenCell) / CGFloat(2)  // 2 = numbers in vertical.
        return CGSize(width: width, height: width) //Square
    }
    
    var sizeOfCellInLandscape: CGSize {
        let viewWidth = landscapeScreenSize?.width ?? self.bounds.width
        let viewHeight = landscapeScreenSize?.height ?? self.bounds.height
        
        let bordes = CGFloat(104) //8 leading + 8 trailling + 88 SafeArea (left and rigth)
        let bordesBetwenCell = CGFloat(16) //8 leading + 8 trailling
        let width = (viewWidth - bordes - bordesBetwenCell) / CGFloat(2)  // 2 = numbers in vertical.
        let height = (viewHeight - bordesBetwenCell)
        return CGSize(width: width, height: height) //Square
    }
    
}

//MARK : - Presentation Logic with HandleState, get all state in ViewController
extension PhotosCollectionView {
    public enum HandleState {
        case performItem
        case none
    }
    
    private func performHandleState() {
        switch self.handleState {
        case .performItem:
            self.reloadData()
        default:
            break
        }
    }
}


extension PhotosCollectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoIds?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let reuseCellItem = ItemCollectionViewCell.reuseCell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellItem, for: indexPath) as? ItemCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        // If loaded the image , dont loaded again
        if listModelCache.keys.contains(indexPath.item)  {
            let photoView = listModelCache[indexPath.item]
            cell.photoView = photoView
            
        } else {
            // If not loaded the image , then loaded it for first time.
            if let id = self.photoIds?[indexPath.item] {
                self.photoManager.getPhoto(photoId: id) { [weak self] (photoView) in
                    if let _ = photoView.errorMessage {
                        return
                    }
                    self?.listModelCache[indexPath.item] = photoView
                    cell.photoView = photoView
                }
            }
        }
        self.shadownInCell(cell)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.isPortrate ? self.sizeOfCellInPortrate : self.sizeOfCellInLandscape
    }
    
    
    private func shadownInCell(_ cell: ItemCollectionViewCell) {
        
        //rounded the cell
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 15
        
        
        //Border for Shadow
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        //Drawing Shadow
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath =
            UIBezierPath(roundedRect: cell.bounds,
                         cornerRadius:cell.contentView.layer.cornerRadius).cgPath
    }
    
}
