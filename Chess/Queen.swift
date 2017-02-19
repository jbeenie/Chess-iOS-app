//
//  Queen.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-15.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class Queen: ChessPiece{
    //MARK: - Properties
    //MARK: Constants
    let color: ChessPieceColor
    let value = 9
    let canJumpOverOtherPieces = false
    let typeId: String = "Q"
    //MARK: Variables
    var position: Position? = nil
    var hasMoved: Bool = false
    var chessBoard: ChessBoard? = nil
    
    //MARK: Methods
    func isValidMove(to newPosition:Position)->Bool {
        //make sure the queen is on the board
        guard let position = self.position else {return false}
        //make sure the queen is moving along the same row, column or diagonal
        guard   nil != position.isOnSameRow(as: newPosition) ||
                nil != position.isOnSameColumn(as: newPosition) ||
                nil != position.isOnSameDiagonal(as: newPosition) else {return false}
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
