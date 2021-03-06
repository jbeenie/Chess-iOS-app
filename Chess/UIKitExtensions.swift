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
    
    mutating func setHeight(to height:CGFloat){
        self = CGRect(origin: self.origin, size: CGSize(width: self.width, height: height))
    }
    
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
    static func animateAlphaTransition(of view:UIView?, toAlpha alpha:CGFloat,  withDuration duration:TimeInterval, delay:TimeInterval,options: UIViewAnimationOptions = [], completion: ((Bool) -> Void)? = nil){
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: options,
                       animations: {view?.alpha = alpha},
                       completion: completion)
        }
    
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderColor: UIColor?{
        get {
            if let borderColor = layer.borderColor{
                return UIColor(cgColor: borderColor)
            }else{return nil}
            
        }
        set {layer.borderColor = newValue?.cgColor ?? nil}
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    
}

extension UIViewController{
    var contentViewController: UIViewController{
        if let navcon = self as? UINavigationController {
            return  navcon.visibleViewController ?? self
        }
        else{
            return self
        }
    }
    
    var previousViewController:UIViewController?{
        if let controllersOnNavStack = self.navigationController?.viewControllers{
            let n = controllersOnNavStack.count
            //if self is still on Navigation stack
            if controllersOnNavStack.last === self, n > 1{
                return controllersOnNavStack[n - 2]
            }else if n > 0{
                return controllersOnNavStack[n - 1]
            }
        }
        return nil
    }
    
    //Hidding key board when user taps outside
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIImage{
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width:size.width * heightRatio,height: size.height * heightRatio)
        } else {
            newSize = CGSize(width:size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: CGPoint.zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension UITapGestureRecognizer{
    convenience init(touchCount:Int, tapCount:Int, target: Any?, action: Selector?){
        self.init(target: target, action: action)
        self.numberOfTouchesRequired = touchCount
        self.numberOfTapsRequired = tapCount
    }
}

//MARK: UICOLOR EXT
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

