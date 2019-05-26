//
//  LoaderImage.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 24/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()
class LoaderImageView: UIImageView {
    
    var imageExist: String?
    
    /**
     if imagecache doesn't have the image then make the download and save the image in imagecache, if else one has image then show
     
     - Parameters:
     - by: It is the Id of Photo
     - withSource: It is the source
    */
    func loadImage(by id: String, withSource urlString:String) {
        
        //There is the image in Disk
        let valueImage = "\(id)-\(urlString)"
        imageExist = valueImage
        self.image = nil
        if let imageForCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageForCache
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let url = URL(string: urlString) else { return }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if data != nil {                    
                    DispatchQueue.main.async {
                        let imageForCache = UIImage(data: data!)
                        if self.imageExist == valueImage {
                            self.image = imageForCache
                        }
                        imageCache.setObject(imageForCache!, forKey: valueImage as AnyObject)
                    }
                }
            }.resume()
        }
    }
}
