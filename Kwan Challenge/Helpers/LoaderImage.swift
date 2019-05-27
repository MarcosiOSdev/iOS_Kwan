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
    
    var newImage: UIImage? {
        didSet {
            guard let image = self.newImage else { return }
            UIView.transition(with: self,
                              duration:0.5,
                              options: .transitionCrossDissolve,
                              animations: { self.image = image },
                              completion: nil)
        }
    }
    
    /**
     if imagecache doesn't have the image then make the download and save the image in imagecache, if else one has image then show
     
     - Parameters:
     - by: It is the Id of Photo
     - withSource: It is the source
    */
    func loadImage(by id: String, withSource urlString:String, completion: ((Bool) -> Void)? = nil) {
        
        //There is the image in Disk
        let valueImage = "\(id)-\(urlString)"
        self.image = nil
        self.imageExist = valueImage
        
        if let imageForCache = imageCache.object(forKey: valueImage as AnyObject) as? UIImage {
            self.newImage = imageForCache
            if let completion = completion {
                completion(true)
            }
            return
        }
        
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in            
            performUIUpdate {
                if let data = data {
                    guard let imageForCache = UIImage(data: data) else {
                        self.image = nil
                        if let completion = completion {
                            completion(true)
                        }
                        return
                    }
                    
                    if self.imageExist == valueImage {
                        self.newImage = imageForCache
                    }
                    
                    imageCache.setObject(imageForCache, forKey: valueImage as AnyObject)
                    if let completion = completion {
                        completion(true)
                    }
                }
            }
        }.resume()
        
    }
}
