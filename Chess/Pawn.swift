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
    
    //MARK: - Methods
    func move(to newPosition: Position, given pawnThatJustDoubleStepped:Pawn?, execute: Bool=true) -> Move? {
        print("*************Pawn is Moving*****")
        //check if the pawn is attempting a prise en passant
        if self.attemptingToCapture(at: newPosition){
            return self.priseEnPassant(to: newPosition, given: pawnThatJustDoubleStepped, execute: execute)
        }else{
            return (self as ChessPiece).move(to: newPosition, execute: execute)
        }
    }

    
    func isValidMove(to newPosition:Position)->Bool {
        //make sure pawn is either moving along the column its in
        //or moving along a diagonal by one square to capture another piece
        
        //Check if the pawn is attempting to capture another piece first:
        if self.attemptingToCapture(at: newPosition){
            //make sure there is a piece to capture
            return (nil != chessBoard[newPosition.row,newPosition.col])
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
    
    //MARK: - Private methods
    
    private func attemptingToCapture(at newPosition:Position)->Bool{
        //Check if pawn is moving diagonally by one square:
        if let  verticalSpacing = position.isOnSameDiagonal(as: newPosition,signed: true),
            abs(verticalSpacing) == 1 {
            //make sure the pawn is moving in the right direction
            return  color == .White ? verticalSpacing > 0 : verticalSpacing < 0
        }
        return false
    }
    
    
    private func priseEnPassant(to newPosition:Position, given pawnThatJustDoubleStepped:Pawn?, execute:Bool=true)->PriseEnPassant?{
        //verify 
        //1. the pawn attempting the prise EnPassant is on the 5th rank
        //2. There is a pawn that just double stepped
        //3. the pawn to capture is in the appropriate position
        //   i.e : adjacent to it on the same row
        //4. double check newPosition is unOccupied
        guard self.rank == 5 else {return nil}
        guard let pawnToCapture = pawnThatJustDoubleStepped else {return nil}
        guard self.position.isOnSameRow(as: pawnToCapture.position) == 1 else {return nil}
        guard self.chessBoard[newPosition.row,newPosition.col] == nil else {return nil}
        //record the prise EnPassant move
        let priseEnPassant = PriseEnPassant(startPosition: self.position, endPosition: newPosition, pieceMoved: self, pieceCaptured: pawnToCapture, firstTimePieceMoved: false)
        
        //execute the move if execute is true
        if execute{
            //move the capturing pawn
            _ = chessBoard.movePiece(from: self.position, to: newPosition)
            //remove the captured pawn
            _ = chessBoard.removePiece(from: pawnToCapture.position)
        }
        return  priseEnPassant
    }
    
//    private func undo(priseEnPassant: PriseEnPassant){
//        //determine the outcome that results in undoing the castle
//        let (pawnWasMovedBack,pieceUnexpectedlyEatenByPawn) = chessBoard.movePiece(from: priseEnPassant.endPosition, to: priseEnPassant.startPosition,execute:  false)
//        let (rookWasMoved,pieceUnexpectedlyEatenByRook) = chessBoard.movePiece(from: priseEnPassant.finalRookPosition, to: priseEnPassant.initialRookPosition, execute:  false)
//        //verify verify the outcome is as expected
//        guard kingWasMoved && rookWasMoved,
//            pieceUnexpectedlyEatenByKing == nil,
//            pieceUnexpectedlyEatenByRook == nil else {
//                print("Could not undo move: \(castle)")
//                print("King was moved:\(kingWasMoved)")
//                print("Rook was moved:\(rookWasMoved)")
//                print("Piece unexpectedly capture by King: \(pieceUnexpectedlyEatenByKing)")
//                print("Piece unexpectedly capture by Rook: \(pieceUnexpectedlyEatenByRook)")
//                return false
//        }
//        //move pawn Back
//        _ = chessBoard.movePiece(from: priseEnPassant.endPosition, to: priseEnPassant.startPosition)
//        //put captured pawn back on board
//        _ = chessBoard.set(piece: priseEnPassant.pieceEaten, at: priseEnPassant.)
//        return true
//    }
    
    
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
