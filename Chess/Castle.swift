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
    let side: Side
    let rook: Rook
    
    //MARK: - Debugging
    override var description: String{
        return "\(super.description), castling Side:\(side)"
    }
    
    //MARL: - Initialization
    init(startPosition:Position, endPosition:Position, pieceEaten:ChessPiece?=nil, firstTimePieceMoved:Bool, side:Side,rook:Rook){
        self.side = side
        self.rook = rook
        super.init(startPosition: startPosition, endPosition: endPosition, pieceEaten: pieceEaten, firstTimePieceMoved: firstTimePieceMoved)
    }
}
