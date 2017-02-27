//
//  ChessPiece.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-15.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

protocol ChessPiece:class{
    //MARK: -Properties
    var initialPosition: Position {get}
    var position: Position {get set}
    var color: ChessPieceColor {get}
    var value: Int {get}
    var canJumpOverOtherPieces: Bool {get}
    var hasMoved: Bool {get set}
    var typeId: String {get}
    var chessBoard: ChessBoard {get}
    var reachableSquares:Set<Position> {get}
    
    
    
    //MARK: Methods
    func isValidMove(to newPosition:Position)->Bool
    
    
    
    //MARK: - Initializers
    init(color: ChessPieceColor, position: Position, chessBoard: ChessBoard)
    
    init(chessPiece:ChessPiece, chessBoard:ChessBoard?)
    
}

extension ChessPiece{
    //MARK: - Debugging
    var description: String{
        return "\(color.rawValue)"+typeId
    }
    
    //MARK: - Computed Properties
    //King of that chesspiece
    var king:King?{return color == .White ? chessBoard.whiteKing : chessBoard.blackKing}
    
    var rank:Int{return (color == .Black ?  position.row + 1 : ChessBoard.Dimensions.SquaresPerColumn - position.row)}
    
    //answers whether or not the piece can move to the new position
    //and executes the move if execute is set to true
    //returns a Move if the move can be executed and nil otherwise
    func move(to newPosition: Position, execute:Bool=true)->Move?{
        let oldPosition = self.position
        //make sure new position is different from current position
        guard oldPosition != newPosition else {return nil}
        //verify the piece is not capturing another piece of the same color
        if let pieceToEat = chessBoard[newPosition.row,newPosition.col], pieceToEat.color == self.color{
            return nil
        }
        //check if the piece can move in that way
        guard isValidMove(to: newPosition) else{return nil}
        //check whether or not piece illegally jumps over other peices
        guard !doesPieceIllegalyJumpOverOtherPieceWhenMoving(to: newPosition) else {return nil}
        
        //verify if the the piece can be moved on the board, 
        //executes the move regardless of whether execute == true
        //then the move is simply undone if execute == false
        let (pieceWasMoved, pieceCaptured) = chessBoard.movePiece(from: oldPosition, to: newPosition, execute: true)
        //if piece couldn't be moved return nil
        guard pieceWasMoved else {return nil}
        //otherwise record the move just executed
        let move = Move(startPosition: oldPosition, endPosition: newPosition, pieceMoved: self, pieceCaptured: pieceCaptured, firstTimePieceMoved: !self.hasMoved)
        //now verify that the move does not leave the king in check
        guard (king?.isInCheck().not()  ?? true) else {
            //if it is in check then undo the move and return nil
            //to indicate the move was unscucessful
            _ = undo(move:move)
            //print("Move could not be applied because \(color) King is left in Check")
            return nil
        }
        //if the king is not left in check and execute is true
        if execute{//indicate piece has move            
            self.hasMoved = true
        }
        else{//if execute is false undo the move
            _ = undo(move:move)
        }
        //return the move to indicate the move can successfully be executed
        return move
    }
    
    //makes the peice undo the specified move
    //returns true if successful otherwise false
    func undo(move:Move){
//        //determine the outcome that results in undoing the move
//        let (pieceWasMoved,unexpectedlyEatenPiece) = chessBoard.movePiece(from: move.endPosition, to: move.startPosition,execute: false)
//        //verify verify the outcome is as expected
//        guard pieceWasMoved && unexpectedlyEatenPiece == nil else {
//            print("Could not undo move: \(move)")
//            print("Piece was moved:\(pieceWasMoved), unexpectedly Eaten Piece: \(unexpectedlyEatenPiece)")
//            return false
//        }
//        //once the outcome is validated undo the move
        _ = chessBoard.movePiece(from: move.endPosition, to: move.startPosition)
        //if it was the first time that piece was moved,
        //reset its hasMoved property to false
        self.hasMoved = move.firstTimePieceMoved ? false : true
        //if a piece was captured during the move
        //put it back on the board
        _ = chessBoard.set(piece: move.pieceCaptured, at: move.pieceCaptured?.position ?? move.endPosition)
    }
    
    
    
    //method used to make sure piece is not jumping over other pieces if it is not supposed to
    func doesPieceIllegalyJumpOverOtherPieceWhenMoving(to position: Position)->Bool{
        if !canJumpOverOtherPieces{
            let oldPosition = self.position
            //if its a move :: a row
            if  oldPosition.isOnSameRow(as: position) != nil &&
                !chessBoard.isRow(oldPosition.row, emptyBetweenColumns: oldPosition.col, position.col){
                //print("Cant Move along row")
                return true
                //if its a move along a column
            }else if oldPosition.isOnSameColumn(as: position) != nil &&
                !chessBoard.isColumn(oldPosition.col, emptyBetweenRows: oldPosition.row, position.row){
                //print("Cant Move along column")
                return true
                //if its a move along a diagonal
            }else if oldPosition.isOnSameDiagonal(as: position) != nil,
                let diagonal = Diagonal(position1: oldPosition, position2: position),
                !chessBoard.isDiagonal(diagonal, emptyBetweenColumns: oldPosition.col, position.col){
                //print("Cant Move along diagonal")
                return true
            }else{
                //print("Line is Clear!")
                return false
            }
        }else{
            return false
        }
    }
    
    func canMove()->Bool{
        for square in reachableSquares{
            if (self.move(to: square, execute: false) != nil){
                return true
            }
        }
        return false
    }
}

//MARK: - Supporting Type
enum ChessPieceColor: Character {
    case White = "W", Black = "B"
    mutating func alternate() {
        switch self {
        case .White:
            self = .Black
        case .Black:
            self = .White
        }
    }
    
    func opposite()->ChessPieceColor{
        switch self {
        case .White:
            return ChessPieceColor.Black
        case .Black:
            return ChessPieceColor.White
        }
    }
}

enum Side:Character{
    case King = "K", Queen = "Q"
}
