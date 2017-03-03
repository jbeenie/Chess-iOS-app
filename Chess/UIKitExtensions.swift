//
//  UIKitExtensions.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-13.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

extension CGRect {
    var mid: CGPoint { return CGPoint(x: midX, y: midY) }
    var upperLeft: CGPoint { return CGPoint(x: minX, y: minY) }
    var lowerLeft: CGPoint { return CGPoint(x: minX, y: maxY) }
    var upperRight: CGPoint { return CGPoint(x: maxX, y: minY) }
    var lowerRight: CGPoint { return CGPoint(x: maxX, y: maxY) }
    
    init(center: CGPoint, size: CGSize) {
        let upperLeft = CGPoint(x: center.x-size.width/2, y: center.y-size.height/2)
        self.init(origin: upperLeft, size: size)
    }
    
    init(lowerRight: CGPoint, size: CGSize){
        let upperLeft = CGPoint(x: lowerRight.x-size.width, y: lowerRight.y-size.height)
        self.init(origin: upperLeft, size: size)
    }
}

extension CGSize {
    static func * (size: CGSize, scale: CGFloat) -> CGSize {
        return CGSize(width: size.width * scale , height: size.height * scale)
    }
}

extension UIView{
    static func animateAlphaTransition(of view:UIView, toAlpha alpha:CGFloat,  withDuration duration:TimeInterval, delay:TimeInterval,options: UIViewAnimationOptions = [], completion: ((Bool) -> Void)? = nil){
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: options,
                       animations: {view.alpha = alpha},
                       completion: completion)
        }
}
