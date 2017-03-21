//
//  ChessGameSettings.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-20.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class ChessGameSettings:ChessSettings{
    let maxTakebacks:TakeBackCount?
    let chessClock:ChessClock?
    
    init(maxTakebacks:TakeBackCount?,
         chessClock:ChessClock?,
         notificationsEnabled:Bool,
         animationsEnable:Bool,
         chessBoardTheme:ChessBoardTheme) {
        self.maxTakebacks = maxTakebacks
        self.chessClock = chessClock
        super.init(notificationsEnabled: notificationsEnabled,animationsEnable: animationsEnable,chessBoardTheme: chessBoardTheme)
    }
    
    convenience init(maxTakebacks:TakeBackCount?,
                     chessClock:ChessClock?, globalSettings:ChessSettings){
        self.init(maxTakebacks:maxTakebacks,
                  chessClock:chessClock,
                  notificationsEnabled:globalSettings.notificationsEnabled,
                  animationsEnable:globalSettings.animationsEnable,
                  chessBoardTheme:globalSettings.chessBoardTheme
        )
    }
    
    
}
