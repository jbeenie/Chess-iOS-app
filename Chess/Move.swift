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
    var endPosition: Position
    let pieceMoved: ChessPiece
    var pieceEaten: ChessPiece?
    let firstTimePieceMoved: Bool
    
    
    var description: String{
        return "\(startPosition.description) -> \(pieceMoved.description) piece eaten: \(pieceEaten?.description), first Time piece moved: \(firstTimePieceMoved)"
    }
    
    init(startPosition:Position, endPosition:Position, pieceMoved:ChessPiece, pieceEaten:ChessPiece?=nil, firstTimePieceMoved:Bool){
        self.startPosition = startPosition
        self.endPosition = endPosition
        self.pieceMoved = pieceMoved
        self.pieceEaten = pieceEaten
        self.firstTimePieceMoved = firstTimePieceMoved
    }
}
