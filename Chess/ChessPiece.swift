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
    var color: ChessPieceColor {get}
    var value: Int {get}
    var canJumpOverOtherPieces: Bool {get}
    var position: Position? {get set}
    var hasMoved: Bool {get set}
    var typeId: String {get}
    var chessBoard: ChessBoard? {get set}
    
    //MARK: Methods
    func isValidMove(to newPosition:Position)->Bool
    
    
    
    //MARK: - Initializers
    init(color: ChessPieceColor, position: Position?, chessBoard: ChessBoard?)
    
    init(chessPiece:ChessPiece)
    
}

extension ChessPiece{
    //MARK: - Debugging
    var description: String{
        return "\(color.rawValue)"+typeId
    }
    
    //answers whether or not the piece can move to the new position
    //and executes the move if execute is set to true
    func move(to newPosition: Position, execute:Bool=true)->Bool{
        //first check piece is on the board
        guard let oldPosition = self.position, let chessBoard = self.chessBoard else{return false}
        //check if the piece can move in that way
        guard isValidMove(to: newPosition) else{return false}
        //check whether or not piece illegally jumps over other peices
        guard !doesPieceIllegalyJumpOverOtherPieceWhenMoving(to: newPosition) else {return false}
        
        //check wether or not the move should actually be executed
        if execute {
            //attempt to move the piece on the board
            let (pieceWasMoved, _) = chessBoard.movePiece(from: oldPosition, to: newPosition)
            //check if move is successful
            guard pieceWasMoved else {return false}
            //update pieces position and record the fact that it has been moved
            self.position = newPosition
            self.hasMoved = true
        }
        //indicate whether the move was successful or not
        return true
    }
    
    //method used to make sure piece is not jumping over other pieces if it is not supposed to
    func doesPieceIllegalyJumpOverOtherPieceWhenMoving(to newPosition: Position)->Bool{
        if let position = self.position, let chessBoard = self.chessBoard, !canJumpOverOtherPieces{
            //if its a move along a row
            if  position.isOnSameRow(as: newPosition) != nil &&
                !chessBoard.isRow(position.row, emptyBetweenColumns: position.col, newPosition.col){
                print("Cant Move along row")
                return true
                //if its a move along a column
            }else if position.isOnSameColumn(as: newPosition) != nil &&
                !chessBoard.isColumn(position.col, emptyBetweenRows: position.row, newPosition.row){
                print("Cant Move along column")
                return true
                //if its a move along a diagonal
            }else if position.isOnSameDiagonal(as: newPosition) != nil,
                let diagonal = Diagonal(position1: position, position2: newPosition),
                !chessBoard.isDiagonal(diagonal, emptyBetweenColumns: position.col, newPosition.col){
                print("Cant Move along diagonal")
                return true
            }else{
                print("Line is Clear!")
                return false
            }
        }else{
            return false
        }
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
