//
//  Castling.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-24.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class Castling: Move{
    //MARK: - Properties
    let side:Side
    let rookInvolved:Rook
    
    //MARK: - Static Methods
    static let squaresTraversedByKing = 2
    static func initialPositionOfRook(with color: ChessPieceColor, on side:Side)->Position{
        let row = (color == .White ? 7 : 0)
        let col = (side == .King ? 7 : 0)
        return Position(row: row, col: col)!
    }
    static func finalPositionOfRook(with color: ChessPieceColor, on side:Side)->Position{
        let row = (color == .White ? 7 : 0)
        let col = (side == .King ? 5 : 3)
        return Position(row: row, col: col)!
    }
    //MARK: - Initializers
    init(startPosition:Position, endPosition:Position, pieceEaten:ChessPiece?=nil, firstTimePieceMoved:Bool, side:Side, rookInvolved:Rook){
        self.side = side
        self.rookInvolved = rookInvolved
        super.init(startPosition: startPosition, endPosition: endPosition, firstTimePieceMoved: firstTimePieceMoved)
    }
}
