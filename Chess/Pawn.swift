//
//  Pawn.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-15.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class Pawn: ChessPiece{
    //MARK: - Properties
    //MARK: Constants
    let color: ChessPieceColor
    let value = 1
    let canJumpOverOtherPieces = false
    let typeId: String = "P"
    //MARK: Variables
    var position: Position? = nil
    var hasMoved: Bool = false
    var chessBoard: ChessBoard? = nil
    
    //MARK: Methods
    func isValidMove(to newPosition:Position)->Bool {
        //make sure the pawn is on the board
        guard let position = self.position, let chessBoard = self.chessBoard else {return false}
        //make sure pawn is either moving along the column its in 
        //or moving along a diagonal by one square to eat another piece
        //TODO: ADD potential for Prise En Passant
        
        //Check diagonal case first:
        if let  verticalSpacing = position.isOnSameDiagonal(as: newPosition,signed: true),
                abs(verticalSpacing) == 1 {
            //make sure the pawn is moving in the right direction
            guard  color == .White ? verticalSpacing > 0 : verticalSpacing < 0 else {return false}
            //make sure there is a piece to eat
            guard nil != chessBoard[newPosition.row,newPosition.col] else {
                print("Pawn can only move diagonal to eat a piece.")
                return false
            }
            return true
        }
        //Deal with the case when it is moving forward
        guard let verticalSpacing = position.isOnSameColumn(as: newPosition, signed: true) else {return false}
        //make sure the pawn is moving in the right direction
        guard  color == .White ? verticalSpacing > 0 : verticalSpacing < 0 else {return false}
        //make sure the pawn is moving either 1 or 2 squares
        guard (1...2).contains(abs(verticalSpacing)) else {
            return false
        }
        //make sure there is no piece in position it wants to move to
        guard nil == chessBoard[newPosition.row,newPosition.col] else {
            print("Pawn can only move forward to an empty square.")
            return false
        }
        //if the pawn is attempting to move up two squares make sure it hasn't moved yet
        return abs(verticalSpacing) == 2 ? self.hasMoved == false : true
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
