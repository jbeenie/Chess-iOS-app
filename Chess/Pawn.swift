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
    let initialPosition: Position
    var position: Position
    var hasMoved: Bool = false
    let chessBoard: ChessBoard
    var reachableSquares: Set<Position> {
        var reachableSquares = Set<Position>()
        var rowOffSet = (color == .White) ? -1 : 1
        //add three reachable squares one row ahead of pawn
        for colOffSet in -1...1{
            if let position = Position(row: position.row+rowOffSet, col: position.col+colOffSet){
                reachableSquares.insert(position)
            }
        }
        if self.hasMoved{
            return reachableSquares
        }
        //if the pawn hasn't moved add the reachable square two rows ahead
        rowOffSet += rowOffSet
        reachableSquares.insert(Position(row: position.row+rowOffSet, col: position.col)!)
        return reachableSquares
    }
    
    //MARK: Methods
    func isValidMove(to newPosition:Position)->Bool {
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
                //print("Pawn can only move diagonal to eat a piece.")
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
