//
//  ChessNotification.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-11.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class ChessNotification: UIView {
    
    struct Animation{
        static let AppearDuration:TimeInterval = 0.3
        static let AppearDelay:TimeInterval = 0
        static let AppearOptions:UIViewAnimationOptions = [.curveLinear]
        
        static let DisAppearDuration:TimeInterval = 0.3
        static let DisAppearDelay:TimeInterval = 0.7
        static let DisAppearOptions:UIViewAnimationOptions = [.curveLinear]
    }
    
    struct Constants{
        static let alignment = NSTextAlignment.center
        static let fontSize:CGFloat = 30
        static let font = UIFont.boldSystemFont(ofSize: fontSize)
    }
    
    
    var label: UILabel = UILabel()
    
    let temporary:Bool
    
    init(frame: CGRect, temporary:Bool) {
        self.temporary = temporary
        super.init(frame: frame)
        self.label.textAlignment = Constants.alignment
        self.label.font = Constants.font
        self.label.numberOfLines = 0
        self.addSubview(label)
        self.isOpaque = false
        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func centerAndResizeLabel(){
        label.sizeToFit()
        label.center = self.frame.mid
        
    }
    
    func animatePosting(){
        
        //make sure alpha is 0
        self.alpha = 0
        UIView.animateAlphaTransition(
            of: self,
            toAlpha: 1,
            withDuration: Animation.AppearDuration,
            delay: Animation.AppearDelay,
            options: Animation.AppearOptions)
        {finished in
            if self.temporary{
                self.animateRemoval()
            }
        }
    }
    
    func animateRemoval(completionHanlder:(()->Void)? = nil){
        UIView.animateAlphaTransition(
            of: self,
            toAlpha: 0,
            withDuration: Animation.DisAppearDuration,
            delay: Animation.DisAppearDelay,
            options: Animation.DisAppearOptions,
            completion:  {finished in self.removeFromSuperview(); completionHanlder?() }
        )
    }
}




