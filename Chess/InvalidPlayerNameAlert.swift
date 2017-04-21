//
//  InvalidPlayerNameAlert.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-04-20.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

//
//  SaveGameAlert.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-04-14.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit


class InvalidPlayerNameAlert{
    
    private static var min: Int {
        return PlayerNames.Constants.minPlayerStringLength
    }
    
    private static var max: Int {
        return PlayerNames.Constants.maxPlayerStringLength
    }
    
    private struct Content{
        static let title:String? = "Invalid Player Name"
        static let message:String? = "A player's name must contain only letters and must be \(min)-\(max) characters long."
    }
    
    static func create()->UIAlertController {
        let alert = UIAlertController(
            title: Content.title,
            message: Content.message,
            preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
    
}
