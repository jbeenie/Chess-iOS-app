//
//  Rook.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-15.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class Rook: ChessPiece{
    //MARK: - Properties
    //MARK: Constants
    let color: ChessPieceColor
    let value = 5
    let canJumpOverOtherPieces = false
    let typeId: String = "R"
    
    //MARK: Variables
    let initialPosition: Position
    var position: Position
    var hasMoved: Bool = false
    let chessBoard: ChessBoard
    var reachableSquares: Set<Position> {
        var reachableSquares = Set<Position>()
        reachableSquares += position.squaresOnSameRow + position.squaresOnSameColumn - [position]
        return reachableSquares
    }
    var side: Side?{
        if initialPosition.col == 0 {return Side.Queen}
        if initialPosition.col == 7 {return Side.King}
        return nil
    }
    
    //MARK: Methods
    func isValidMove(to newPosition:Position)->Bool {
        //make sure the rook is moving along the same row or column
        guard   nil != position.isOnSameRow(as: newPosition) ||
                nil != position.isOnSameColumn(as: newPosition) else {return false}
        //otherwiseMove is Legal
        return true
    }
    
    
    //MARK: - Initializers
    required init(color: ChessPieceColor, position:Position, chessBoard:ChessBoard){
        self.color = color
        self.position = position
        self.initialPosition = position
        self.chessBoard = chessBoard
    }
    
    required init(chessPiece: ChessPiece, chessBoard:ChessBoard?=nil){
        self.color = chessPiece.color
        self.position = chessPiece.position
        self.initialPosition = chessPiece.initialPosition
        self.chessBoard = chessBoard ?? chessPiece.chessBoard
    }
}
