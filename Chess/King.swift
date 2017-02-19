//
//  King.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-15.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class King: ChessPiece{
    //MARK: - Properties
    //MARK: Constants
    let color: ChessPieceColor
    let value = 0
    let canJumpOverOtherPieces = false
    let typeId: String = "K"
    //MARK: Variables
    var position: Position? = nil
    var hasMoved: Bool = false
    var chessBoard: ChessBoard? = nil
    
    //MARK: Methods
    func isValidMove(to newPosition:Position)->Bool {
        //make sure the king is on the board
        guard let position = self.position else {return false}
        //make sure the king is moving along the same row, column or diagonal by exactly one square
        guard   1 == position.isOnSameRow(as: newPosition) ||
                1 == position.isOnSameColumn(as: newPosition) ||
                1 == position.isOnSameDiagonal(as: newPosition) else {return false}
        //otherwiseMove is Legal
        return true
    }
    
    
    //MARK: - Initializers
    required init(color: ChessPieceColor, position:Position? = nil, chessBoard:ChessBoard?=nil){
        self.color = color
        self.position = position
        self.chessBoard = chessBoard
    }
    
    required init(chessPiece: ChessPiece){
        self.color = chessPiece.color
        self.position = chessPiece.position
        self.chessBoard = chessPiece.chessBoard
    }
}
