//
//  MFShimmerView.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 24/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import UIKit

var associateObjectValue: Int = 0
extension UIView {
    
    private var isAnimate: Bool {
        get {
            return objc_getAssociatedObject(self, &associateObjectValue) as? Bool ?? false
        }
        set {
            return objc_setAssociatedObject(self, &associateObjectValue, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    @IBInspectable var isShimmering: Bool {
        get {
            return isAnimate
        }
        set {
            self.isAnimate = newValue
            newValue ? self.startShimmer() : self.stopShimmer()
        }
    }
    
    func subviewsRecursive() -> [UIView] {
        return subviews + subviews.flatMap { $0.subviewsRecursive() }
    }
    
    /**
     Start all animation with shimmer in view or in all over subViews.
     
     - Parameters:
        - view: Just view that you want to stop or if you dont set it , stop all view children and the same.
        - alpha: Default alpha is 0.4 , but you can set the alpha gradiante
        - duration: Default duration is 1 seconds for start and finish the animation
     */
    func startShimmer(view outView: UIView? = nil,
                      alpha: CGFloat = 0.4,
                      duration: CFTimeInterval = 1.0) {
        
        var listViews = [UIView]()
        if let view = outView {
            listViews.append(view)
        } else {
            listViews.append(contentsOf: getSubViewsForAnimate())
        }
        
        for animateView in listViews {
            animateView.clipsToBounds = true
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.withAlphaComponent(alpha).cgColor, UIColor.clear.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.7, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.8)
            gradientLayer.frame = animateView.bounds
            animateView.layer.mask = gradientLayer
            
            let animation = CABasicAnimation(keyPath: "transform.translation.x")
            animation.duration = duration
            animation.fromValue = -animateView.frame.size.width
            animation.toValue = animateView.frame.size.width
            animation.repeatCount = .infinity
            
            gradientLayer.add(animation, forKey: "")
        }
    }
    
    /**
     Stop all animation with shimmer in view or in all over subViews.
     
     - Parameters:
        - view: Just view that you want to stop or if you dont set it , stop all view children and the same.
     */
    func stopShimmer(view: UIView? = nil) {
        if let view = view {
            view.layer.removeAllAnimations()
            view.layer.mask = nil
        } else {
            for animateView in getSubViewsForAnimate() {
                animateView.layer.removeAllAnimations()
                animateView.layer.mask = nil
            }
        }
    }
    
    private func getSubViewsForAnimate() -> [UIView] {
        var obj: [UIView] = []
        for objView in self.subviewsRecursive() {
            obj.append(objView)
        }
        return obj.filter({ (obj) -> Bool in
            obj.isShimmering
        })
    }
}
