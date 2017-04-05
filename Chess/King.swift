//
//  King.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-15.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class King:CodeableChessPiece, ChessPiece{
    //MARK: - Type Properties
    static var typeId:ChessPieceType = .King
    
    //MARK: - Properties
    //MARK: Constant Properties
    let value = 0
    let canJumpOverOtherPieces = false
    let typeId: ChessPieceType = King.typeId
    
    //MARK: - Computed Properties
    var reachableSquares: Set<Position> {
        var reachableSquares = Set<Position>()
        reachableSquares += position.adjacentSquares
        return reachableSquares
    }
    
    //MARK: - Methods
    func move(to newPosition: Position, execute: Bool=true) -> Move? {
        print("*************King is Moving*****")
        //check if the king is attempting to Castle
        if self.attemptingToCastle(to: newPosition){
            return self.castle(to: newPosition, execute: execute)
        }else{
            return (self as ChessPiece).move(to: newPosition, execute: execute)
        }
    }
    
    
    
    func isValidMove(to newPosition:Position)->Bool {
        //make sure the king is moving along the same row, column or diagonal by exactly one square
        guard   1 == position.isOnSameRow(as: newPosition) ||
                1 == position.isOnSameColumn(as: newPosition) ||
                1 == position.isOnSameDiagonal(as: newPosition) else {return false}
        //otherwiseMove is Legal
        return true
    }
    
    func isInCheck()->Bool{
        return chessBoard.pieceUnderAttack(chessPiece: self)
    }
    
    //MARK: - Private Methods
    //check if king is initial position and 
    //new position is two squares away from current position on same row
    private func attemptingToCastle(to newPosition:Position)->Bool{
        guard let squaresTraversedByKing = position.isOnSameRow(as: newPosition)
            else {return false}
        return !self.hasMoved && abs(squaresTraversedByKing) == Castle.squaresTraversedByKing
    }
    
    private func castle(to newPosition: Position, execute:Bool=true)->Castle?{
        //check what side the king is attempting to Castle on
        //and check that the rook involved has not moved yet
        let castlingSide =  position.col < newPosition.col ? Side.King : Side.Queen
        //get the initial position of rookinvolved
        let initialPosOfRook = Castle.initialPositionOfRook(with: color, on: castlingSide)
        //get the piece located at this position 
        //and verify 
        //1. its a rook 
        //2. its the rook of the appropriate side
        //3. it hasn't moved yet
        guard   let rookInvolved = chessBoard[initialPosOfRook.row, initialPosOfRook.col] as? Rook,
                rookInvolved.side == castlingSide,
                !rookInvolved.hasMoved
        else{return nil}
        //verify that the following squares are neither under attack or occupied:
        //1.square king is currently in
        //2. square king passes through
        //3. square king ends up in
        let positions = position.squaresOnSameRowWithin(col1: position.col, col2: newPosition.col)
        guard !chessBoard.areAnySquaresUnderAttck(at: positions, from: color.opposite()) else {return nil}
        guard chessBoard.isRow(position.row, emptyBetweenColumns: position.col, initialPosOfRook.col, inclusive: false) else {return nil}
        //create the castling move 
        let castle = Castle(startPosition: self.position, endPosition: newPosition, pieceMoved: self, pieceEaten: nil, firstTimePieceMoved: true, rook:rookInvolved)
        //Execute the castling move if execute is true
        if execute{
            //move the king
            _ = chessBoard.movePiece(from: self.position, to: newPosition)
            //move the rook
            _ = chessBoard.movePiece(from: rookInvolved.position, to: Castle.finalPositionOfRook(with: color, on: castlingSide))
        }
        return castle
    }
    
    func undo(castle:Castle){
        //move king Back
        _ = chessBoard.movePiece(from: castle.endPosition, to: castle.startPosition)
        //move the rook back
        _ = chessBoard.movePiece(from: castle.finalRookPosition, to: castle.initialRookPosition)
        //reset hasMoved properties to false
        //because it was the first time that king and rook were moved
        castle.pieceMoved.hasMoved = false
        castle.rook.hasMoved = false
    }
}
