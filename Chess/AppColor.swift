//
//  AppColor.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-04-26.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

import UIKit
import AdvancedDataStructures

internal struct AppColor{
    //Flashy Green for icon/logo
    static let greenFromAppIcon = UIColor(red: 26, green: 217, blue: 104)
    
    //Forest Greens
    static let forestGreen1 = UIColor(red: 32, green: 88, blue: 31)
    static let forestGreen2 = UIColor(red: 11, green: 67, blue: 30)
    static let forestGreen3 = UIColor(red: 13, green: 56, blue: 0)
    static let forestGreen4 = UIColor(red: 38, green: 77, blue: 0)
    
    //Off Whites
    static let offWhite1 = UIColor(red: 239, green: 232, blue: 205)
    static let offWhite2 = UIColor(red: 219, green: 219, blue: 222)
    static let offWhite3 = UIColor(red: 237, green: 232, blue: 216)
    static let offWhite4 = UIColor(red: 241, green: 242, blue: 245)
    
    //TODO: Change to injection
    static var injection:Injection<String,UIColor>{
        let injection = Injection<String,UIColor>(
            pairs: [("white",UIColor.white),
                    ("gray",UIColor.gray),
                    ("green",UIColor.green),
                    ("yellow",UIColor.yellow),
                    ("brown",UIColor.brown),
                    ("greenFromAppIcon",greenFromAppIcon),
                    ("forestGreen1",forestGreen1),
                    ("forestGreen2",forestGreen2),
                    ("forestGreen3",forestGreen3),
                    ("forestGreen4",forestGreen4),
                    ("offWhite1",offWhite1),
                    ("offWhite2",offWhite2),
                    ("offWhite3",offWhite3),
                    ("offWhite4",offWhite4)])!
        return injection
        
    }
    
}




