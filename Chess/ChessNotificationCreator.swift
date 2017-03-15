//
//  ChessNotificationCreator.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-14.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class ChessNotificationCreator{
    
    static var notificationText:[Outcome:String] = [
        Outcome.Check: "Check!",
        Outcome.Draw: "Draw!",
        Outcome.Win(.White, .CheckMate): winNotificationText(for: .White, reason: .CheckMate),
        Outcome.Win(.White, .TimerUp): winNotificationText(for: .White, reason: .TimerUp),
        Outcome.Win(.Black, .CheckMate): winNotificationText(for: .White, reason: .CheckMate),
        Outcome.Win(.Black, .TimerUp): winNotificationText(for: .Black, reason: .TimerUp)
    ]
    
    static var notificationTemporary:[Outcome:Bool] = [
        Outcome.Check: true,
        Outcome.Draw: false,
        Outcome.Win(.White, .CheckMate): false,
        Outcome.Win(.White, .TimerUp): false,
        Outcome.Win(.Black, .CheckMate): false,
        Outcome.Win(.Black, .TimerUp): false
    ]
    
    private static func winNotificationText(for color:ChessPieceColor, reason: Outcome.Reason)->String{
        var text = reason == .CheckMate ? "Check Mate!" : "Timer Up!"
        text += "\(color) Wins!"
        return text
    }
    //String displayed by the notification
    static func createChessNotification(type:Outcome, frame: CGRect)->ChessNotification{
        let chessNotification = ChessNotification(frame: frame,temporary: notificationTemporary[type]!)
        chessNotification.text = notificationText[type]
        return chessNotification
    }
}
