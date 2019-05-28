//
//  PhotosCollectionView.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 25/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import UIKit

protocol PhotosCollectionDelegate: AnyObject {
    func nextPage(_ page: Int)
    func didTap(on photoView: PhotoModel.PhotoView)
}

class PhotosCollectionView: UICollectionView {
    
    weak var photoDelegate: PhotosCollectionDelegate?
    
    //Manager Obj
    var photoManager = PhotoManager()
    
    //photoIds
    var photoIds: [String]?
    
    
    //Var when get more item, for dont call again the same page
    var isGettingMoreItem: Bool = false
    
    //Total item in this page
    var totalItem:Int = 0
    
    //Current Page
    var currentPage:Int {
        return self.searchPhotoView?.page ?? 0
    }
    
    //Verify if current page is less that total
    var hasMoreItem: Bool {
        guard let totalPages = self.searchPhotoView?.totalPage else { return false }
        return totalPages > currentPage
    }
    
    var searchPhotoView: SearchPhotosModel.SearchPhotosView? {
        didSet {
            guard let searchPhotoView = searchPhotoView else { return }
            
            if self.photoIds == nil || self.photoIds?.count == 0 {
                self.photoIds = searchPhotoView.photoIds
            } else {
                self.photoIds?.append(contentsOf: searchPhotoView.photoIds)
            }
            
            self.totalItem += self.searchPhotoView?.photosPerPage ?? 0
            self.handleState = .performItem
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
        case getMoreItem
        case tapOnCell(PhotoModel.PhotoView)
        case none
    }
    
    private func performHandleState() {
        switch self.handleState {
        case .performItem:
            self.reloadData()
            self.isGettingMoreItem = false
        case .getMoreItem:
            self.isGettingMoreItem = true
            self.photoDelegate?.nextPage(self.currentPage + 1)
        case .tapOnCell(let modelView):
            self.photoDelegate?.didTap(on: modelView)
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
        
        self.loadingCell(cell, at: indexPath)
        self.shadownInCell(cell)
        self.verifyMoreLoading(at: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ItemCollectionViewCell,
            let modelView = cell.photoView else { return }
        
        self.handleState = .tapOnCell(modelView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.isPortrate ? self.sizeOfCellInPortrate : self.sizeOfCellInLandscape
    }
    
    private func verifyMoreLoading(at indexPath: IndexPath) {
        if hasMoreItem && !isGettingMoreItem{
            let currentItem = indexPath.item
            let minimunItem = 4
            if currentItem + minimunItem >= self.totalItem {
                self.handleState = .getMoreItem
            }
            
        }
    }
    
    private func loadingCell(_ cell: ItemCollectionViewCell, at indexPath: IndexPath) {
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
