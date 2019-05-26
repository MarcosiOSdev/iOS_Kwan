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
                self.statePresentation = .performItem
            }
        }
    }
    
    private var statePresentation: HandleState = .none {
        didSet {
            self.performHandleState()
        }
    }
    
    private enum HandleState {
        case performItem
        case none
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.initCustom()
    }
    
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

extension PhotosCollectionView {
    private func performHandleState() {
        switch self.statePresentation {
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
        
        if let id = self.photoIds?[indexPath.item] {
            self.photoManager.getPhoto(photoId: id) { (photoView, error) in
                if let photoView = photoView {
                    DispatchQueue.main.async {
                        cell.photoView = photoView
                    }
                }
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.isPortrate ? self.sizeOfCellInPortrate : self.sizeOfCellInLandscape
    }
    
}
