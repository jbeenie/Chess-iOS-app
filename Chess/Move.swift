//
//  Move.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-24.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class Move{
    let startPosition: Position
    let endPosition: Position
    var pieceEaten: ChessPiece?
    let firstTimePieceMoved: Bool
    
    var description: String{
        return "\(startPosition.description) -> \(endPosition.description) piece eaten: \(pieceEaten?.description), first Time piece moved: \(firstTimePieceMoved)"
    }
    
    init(startPosition:Position, endPosition:Position, pieceEaten:ChessPiece?=nil, firstTimePieceMoved:Bool){
        self.startPosition = startPosition
        self.endPosition = endPosition
        self.pieceEaten = pieceEaten
        self.firstTimePieceMoved = firstTimePieceMoved
    }
}
