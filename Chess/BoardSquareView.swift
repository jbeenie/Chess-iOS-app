//
//  BoardSquare.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-10.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

@IBDesignable
class BoardSquareView: UIView {
    @IBInspectable var color: UIColor
    
    //invoked when view is created from code
    convenience init(color: UIColor){
        self.init(frame: CGRect.zero, color: color)
        self.backgroundColor = self.color
    }
    
    //invoked when view is created from code
    init(frame: CGRect, color: UIColor){
        self.color = color
        super.init(frame: frame)
        self.backgroundColor = self.color
    }
    
    
    //used when view comes out of storyboard
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
