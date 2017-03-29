//
//  ViewOrientationManager.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-28.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation
import UIKit

class ViewOrientationManager{
    
    struct Animation{
        static let RotationDuration: TimeInterval = 0.4
        static let RotationDelay: TimeInterval = 0.1
        static let RotationOptions: UIViewAnimationOptions = [UIViewAnimationOptions.curveEaseInOut,UIViewAnimationOptions.beginFromCurrentState]
    }
    
    var rotationAngle = CGFloat.pi
    
    var currentRotationAngle: CGFloat = 0
    
    var animate: Bool = true
    
    var views:[UIView] = [UIView]()
    
    func rotateViews(by rotationAngle: CGFloat? = nil, completion: (()->Void)?=nil){
        for view in views{
            var onCompletion:(()->Void)? = nil
            if view === views.last{
                onCompletion = completion
            }
            rotate(view: view, by:rotationAngle, completion: onCompletion)
        }
        currentRotationAngle = rotationAngle ?? self.rotationAngle
    }
    
    private func rotate(view:UIView, by rotationAngle:CGFloat? = nil, completion: (()->Void)?=nil){
        let rotateView = {view.transform = CGAffineTransform(rotationAngle: rotationAngle ?? self.rotationAngle)}
        if animate{
            UIView.animate(
                withDuration: Animation.RotationDuration,
                delay: Animation.RotationDelay,
                options: Animation.RotationOptions,
                animations:rotateView,
                completion: { finished in completion?()})
        }else{
            rotateView()
        }
    }
    
    func toggleOrientation(completion: (()->Void)?=nil){
        let angleToRotateTo = (currentRotationAngle == 0) ? rotationAngle : 0
        rotateViews(by: angleToRotateTo, completion: completion)
        currentRotationAngle = angleToRotateTo
    }
    
    init(rotationAngle:CGFloat,views:[UIView] = [UIView](), animate:Bool) {
        self.rotationAngle = rotationAngle
        self.views = views
        self.animate = animate
    }
    
    
}
