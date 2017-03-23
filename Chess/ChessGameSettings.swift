//
//  ChessGameSettings.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-20.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class ChessGameSettings{
    let maxTakebacks:TakeBackCount
    let chessClock:ChessClock?
    
    var animationsEnabled:Bool{
        return globalSettings[ChessSettings.Key.animationsEnabled] as! Bool
    }
    var notificationsEnabled:Bool{
        return globalSettings[ChessSettings.Key.notificationsEnabled] as! Bool
    }
    var chessBoardTheme:ChessBoardTheme{
        return globalSettings[ChessSettings.Key.chessBoardTheme] as! ChessBoardTheme
    }
    
    //up to date global settings
    var globalSettings:ImmutableChessSettings = ImmutableChessSettings()
    
    init(maxTakebacks:TakeBackCount,
         chessClock:ChessClock?){
        self.maxTakebacks = maxTakebacks
        self.chessClock = chessClock
    }
    
    
}
