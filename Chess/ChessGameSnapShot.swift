//
//  ChessGameSnapShot.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-04-08.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

struct ChessGameSnapShot{
    let gameSnapShot: ChessGame
    let clockSnapShot: ChessClock?
    let whiteTakebacksRemaining: TakebackCount
    let blackTakebacksRemaining: TakebackCount
    
    mutating func update(gameSnapShot: ChessGame,
                         clockSnapShot:ChessClock?,
                         whiteTakebacksRemaining: TakebackCount,
                         blackTakebacksRemaining: TakebackCount){
        self = ChessGameSnapShot(gameSnapShot: gameSnapShot,
                                 clockSnapShot: clockSnapShot,
                                 whiteTakebacksRemaining: whiteTakebacksRemaining,
                                 blackTakebacksRemaining: blackTakebacksRemaining)
    }
}
