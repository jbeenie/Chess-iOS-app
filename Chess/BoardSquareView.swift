//
//  BoardSquare.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-10.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit


class BoardSquareView: UIView {
    
    @IBInspectable var color: UIColor
    @IBInspectable var selectedColor: UIColor
    
    var selected: Bool = false{
        didSet{
            backgroundColor = selected ? selectedColor : color
            setNeedsDisplay()
        }
    }
    
//    //invoked when view is created from code
//    convenience init?(color: UIColor){
//        self.init(frame: CGRect.zero, color: color, selectedColor: Default.selectedColor)
//    }
//    
//    //invoked when view is created from code
//    convenience init?(frame: CGRect, color: UIColor){
//        self.init(frame: frame, color: color, selectedColor: Default.selectedColor)
//    }
    
    //invoked when view is created from code
    init?(frame: CGRect, color: UIColor, selectedColor: UIColor){
        //initializer fails to prevent the situation where 
        //the color of a square is the same as its selected color
        if color == selectedColor{
            return nil
        }
        self.color = color
        self.selectedColor = selectedColor
        self.selected = false
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
