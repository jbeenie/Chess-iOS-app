//
//  Castle.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-25.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class Castle: Move{
    //MARK: - Static 
    //MARK: Methods
    static func initialPositionOfRook(with color: ChessPieceColor, on side:Side)->Position{
        let row = (color == .White ? RowOfWhiteRook: RowOfBlackRook)
        let col = ( side == .King ? initialColOfKingSideRook : initialColOfQueenSideRook )
        return Position(row: row, col: col)!
    }
    
    static func finalPositionOfRook(with color: ChessPieceColor, on side: Side)->Position{
        let row = (color == .White ? RowOfWhiteRook: RowOfBlackRook)
        let col = ( side == .King ? finalColOfKingSideRook : finalColOfQueenSideRook )
        return Position(row: row, col: col)!
    }
    
    //MARK: Properties
    private static let RowOfWhiteRook = 7
    private static let RowOfBlackRook = 0
    //Initial columns of rooks before castling
    private static let initialColOfKingSideRook = 7
    private static let initialColOfQueenSideRook = 0
    
    //final columns of rooks after castling
    private static let finalColOfKingSideRook = 5
    private static let finalColOfQueenSideRook = 3
    
    static let squaresTraversedByKing = 2
    //MARK: - Properties
    //Stored
    let rook: Rook
    //Computed
    var side: Side{return rook.side!}
    var initialRookPosition: Position{
        return Castle.initialPositionOfRook(with: rook.color, on: side)
    }
    var finalRookPosition: Position{
        return Castle.finalPositionOfRook(with: rook.color, on: side)
    }
    
    //MARK: - Debugging
    override var description: String{
        return "\(super.description), castling Side:\(side)"
    }
    
    //MARK: - Initialization
    init(startPosition:Position, endPosition:Position, pieceMoved:ChessPiece, pieceEaten:ChessPiece?=nil, firstTimePieceMoved:Bool,rook:Rook){
        self.rook = rook
        super.init(startPosition: startPosition, endPosition:endPosition, pieceMoved: pieceMoved, pieceEaten: pieceEaten, firstTimePieceMoved: firstTimePieceMoved)
    }
}
