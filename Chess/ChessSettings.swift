//
//  ChessSettings.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-20.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class ChessSettings{
    //MARK: - Properties
    
    struct Default{
        static let chessBoardTheme = ChessBoardThemes.GreenWhite
        static let notificationsEnabled = true
        static let animationsEnable = true
    }
    
    var notificationsEnabled:Bool = Default.notificationsEnabled
    var animationsEnable:Bool = Default.animationsEnable
    var chessBoardTheme:ChessBoardTheme = Default.chessBoardTheme
    
    init(notificationsEnabled: Bool,animationsEnable:Bool,chessBoardTheme:ChessBoardTheme) {
        self.notificationsEnabled = notificationsEnabled
        self.animationsEnable = animationsEnable
        self.chessBoardTheme = chessBoardTheme
    }
    
    convenience init(){
        self.init(notificationsEnabled: Default.notificationsEnabled,animationsEnable:Default.animationsEnable,chessBoardTheme:Default.chessBoardTheme)
    }
}
