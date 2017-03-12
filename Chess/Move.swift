//
//  Move.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-24.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class Move{
    static let promotionRank = ChessBoard.Dimensions.SquaresPerColumn
    
    let startPosition: Position
    var endPosition: Position
    let pieceMoved: ChessPiece
    var pieceCaptured: ChessPiece?
    let firstTimePieceMoved: Bool
    var pieceToPromoteTo:ChessPiece?=nil
    
    var promotionOccured: Bool{
        return (pieceMoved is Pawn && pieceMoved.rank(ifAt:endPosition) == Move.promotionRank)
    }
    
    func isPawnDoubleStep()->Bool{
        return  (pieceMoved is Pawn) && abs(startPosition.row - endPosition.row) == 2
    }
    
    
    var description: String{
        return "\(startPosition.description) -> \(pieceMoved.description) piece captured: \(pieceCaptured?.description), first Time piece moved: \(firstTimePieceMoved)"
    }
    
    init(startPosition:Position, endPosition:Position, pieceMoved:ChessPiece, pieceCaptured:ChessPiece?=nil, firstTimePieceMoved:Bool){
        self.startPosition = startPosition
        self.endPosition = endPosition
        self.pieceMoved = pieceMoved
        self.pieceCaptured = pieceCaptured
        self.firstTimePieceMoved = firstTimePieceMoved
    }
    
}
