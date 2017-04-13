//
//  PlayerNames.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-04-11.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

public struct PlayerNames{
    private struct Constants{
        static let maxPlayerStringLength = 15
        static let minPlayerStringLength = 1
    }
    
    var white:String
    var black:String
    
    //Makes sure the length of the player names are within the allowable range
    var areValid:Bool{
        return validate(playerName:self.white) && validate(playerName:self.black)
    }
    
    private func validate(playerName:String)->Bool{
        return playerName.length >= Constants.minPlayerStringLength
            && playerName.length <= Constants.maxPlayerStringLength
    }
}
