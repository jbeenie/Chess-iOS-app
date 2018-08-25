//
//  NamedUIColor.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-04-25.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class NamedUIColor{
    //MARK: -  API
    public let name: String
    public let color: UIColor
    
    //MARK: Initializers
    
    init(color:UIColor, name:String) {
        self.color = color
        self.name = name
        NamedUIColor._injection[name] = color
    }
    
    //MARK: Static
    
    public static var injection:Injection<String,UIColor>{
        return _injection
    }
    
    //TODO: - Implement this function
    //public static func remove(namedColor:)
    
    //MARK: Private
    private  static var _injection:Injection<String,UIColor> = Injection<String,UIColor>()
    
    
}
