//
//  ChessGame.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-15.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class ChessGame{
    //MARK: Constants
    static let pieceInitiallyAt: [Position:ChessPiece] = [
        //Initial position of Black Pieces
        Position(row: 0,col: 0)!: Rook(color: ChessPieceColor.Black),
        Position(row: 0,col: 1)!: Knight(color: ChessPieceColor.Black),
        Position(row: 0,col: 2)!: Bishop(color: ChessPieceColor.Black),
        Position(row: 0,col: 3)!: Queen(color: ChessPieceColor.Black),
        Position(row: 0,col: 4)!: King(color: ChessPieceColor.Black),
        Position(row: 0,col: 5)!: Bishop(color: ChessPieceColor.Black),
        Position(row: 0,col: 6)!: Knight(color: ChessPieceColor.Black),
        Position(row: 0,col: 7)!: Rook(color: ChessPieceColor.Black),
        Position(row: 1,col: 0)!: Pawn(color: ChessPieceColor.Black),
        Position(row: 1,col: 1)!: Pawn(color: ChessPieceColor.Black),
        Position(row: 1,col: 2)!: Pawn(color: ChessPieceColor.Black),
        Position(row: 1,col: 3)!: Pawn(color: ChessPieceColor.Black),
        Position(row: 1,col: 4)!: Pawn(color: ChessPieceColor.Black),
        Position(row: 1,col: 5)!: Pawn(color: ChessPieceColor.Black),
        Position(row: 1,col: 6)!: Pawn(color: ChessPieceColor.Black),
        Position(row: 1,col: 7)!: Pawn(color: ChessPieceColor.Black),
        //Initial position of White Pieces
        Position(row: 6,col: 0)!: Pawn(color: ChessPieceColor.White),
        Position(row: 6,col: 1)!: Pawn(color: ChessPieceColor.White),
        Position(row: 6,col: 2)!: Pawn(color: ChessPieceColor.White),
        Position(row: 6,col: 3)!: Pawn(color: ChessPieceColor.White),
        Position(row: 6,col: 4)!: Pawn(color: ChessPieceColor.White),
        Position(row: 6,col: 5)!: Pawn(color: ChessPieceColor.White),
        Position(row: 6,col: 6)!: Pawn(color: ChessPieceColor.White),
        Position(row: 6,col: 7)!: Pawn(color: ChessPieceColor.White),
        Position(row: 7,col: 0)!: Rook(color: ChessPieceColor.White),
        Position(row: 7,col: 1)!: Knight(color: ChessPieceColor.White),
        Position(row: 7,col: 2)!: Bishop(color: ChessPieceColor.White),
        Position(row: 7,col: 3)!: Queen(color: ChessPieceColor.White),
        Position(row: 7,col: 4)!: King(color: ChessPieceColor.White),
        Position(row: 7,col: 5)!: Bishop(color: ChessPieceColor.White),
        Position(row: 7,col: 6)!: Knight(color: ChessPieceColor.White),
        Position(row: 7,col: 7)!: Rook(color: ChessPieceColor.White)
    ]
    
    //MARK: - Properties
    var colorWhoseTurnIs: ChessPieceColor {
        return _colorWhoseTurnIs
    }
    private var _colorWhoseTurnIs: ChessPieceColor = ChessPieceColor.White
    
    private var chessBoard = ChessBoard() //no pieces placed initially
    
    //MARK: - Methods
    
    func piece(at position:Position)->ChessPiece?{
        return chessBoard.piece(at: position)
    }
    
    func movePiece(from oldPosition: Position, to newPosition: Position)->Bool {
        
        //check if there is even a piece to move at the oldPosition
        guard let pieceToMove = chessBoard[oldPosition.row,oldPosition.col] else { return false }
        //check if it is the appropriate color, 
        //i.e. it is that colors turn to move
        guard pieceToMove.color == colorWhoseTurnIs else { return false }
        //verify the newPosition is unoccupied or occupied by a piece of different color
        if let pieceToEat = chessBoard[newPosition.row,newPosition.col], pieceToEat.color == pieceToMove.color{
            return false
        }
        //ask the piece to move itself to the new position and check if the move succeeds
        //this updates the piece position on the board and within its own class
        guard pieceToMove.move(to: newPosition) else {return false}
        _colorWhoseTurnIs.alternate()
        print(chessBoard.description)//debugging
        return true
    }
    
    func PlacePiecesInInitialPositions(){
        let whiteRowRange = 0...1
        let blackRowRange = 6...7
        for row in [whiteRowRange, blackRowRange].joined(){
            for col in 0..<ChessBoardView.Dimensions.SquaresPerRow{
                if let position = Position(row:row,col:col){
                    if let pieceToPlace = ChessGame.pieceInitiallyAt[position]{
                        pieceToPlace.position = position
                        pieceToPlace.chessBoard = chessBoard
                        _ = chessBoard.set(piece: pieceToPlace, at: position)
                    }
                }
            }
        }

    }
    
}
