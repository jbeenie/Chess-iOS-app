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
    static let pieceInitiallyAt: [ChessBoard.Position:ChessPiece] = [
        //Initial position of Black Pieces
        ChessBoard.Position(row: 0,col: 0)!: ChessPiece(color: ChessPiece.ChessPieceColor.Black),
        ChessBoard.Position(row: 0,col: 1)!: ChessPiece(color: ChessPiece.ChessPieceColor.Black),
        ChessBoard.Position(row: 0,col: 2)!: ChessPiece(color: ChessPiece.ChessPieceColor.Black),
        ChessBoard.Position(row: 0,col: 3)!: ChessPiece(color: ChessPiece.ChessPieceColor.Black),
        ChessBoard.Position(row: 0,col: 4)!: ChessPiece(color: ChessPiece.ChessPieceColor.Black),
        ChessBoard.Position(row: 0,col: 5)!: ChessPiece(color: ChessPiece.ChessPieceColor.Black),
        ChessBoard.Position(row: 0,col: 6)!: ChessPiece(color: ChessPiece.ChessPieceColor.Black),
        ChessBoard.Position(row: 0,col: 7)!: ChessPiece(color: ChessPiece.ChessPieceColor.Black),
        ChessBoard.Position(row: 1,col: 0)!: ChessPiece(color: ChessPiece.ChessPieceColor.Black),
        ChessBoard.Position(row: 1,col: 1)!: ChessPiece(color: ChessPiece.ChessPieceColor.Black),
        ChessBoard.Position(row: 1,col: 2)!: ChessPiece(color: ChessPiece.ChessPieceColor.Black),
        ChessBoard.Position(row: 1,col: 3)!: ChessPiece(color: ChessPiece.ChessPieceColor.Black),
        ChessBoard.Position(row: 1,col: 4)!: ChessPiece(color: ChessPiece.ChessPieceColor.Black),
        ChessBoard.Position(row: 1,col: 5)!: ChessPiece(color: ChessPiece.ChessPieceColor.Black),
        ChessBoard.Position(row: 1,col: 6)!: ChessPiece(color: ChessPiece.ChessPieceColor.Black),
        ChessBoard.Position(row: 1,col: 7)!: ChessPiece(color: ChessPiece.ChessPieceColor.Black),
        //Initial position of White Pieces
        ChessBoard.Position(row: 6,col: 0)!: ChessPiece(color: ChessPiece.ChessPieceColor.White),
        ChessBoard.Position(row: 6,col: 1)!: ChessPiece(color: ChessPiece.ChessPieceColor.White),
        ChessBoard.Position(row: 6,col: 2)!: ChessPiece(color: ChessPiece.ChessPieceColor.White),
        ChessBoard.Position(row: 6,col: 3)!: ChessPiece(color: ChessPiece.ChessPieceColor.White),
        ChessBoard.Position(row: 6,col: 4)!: ChessPiece(color: ChessPiece.ChessPieceColor.White),
        ChessBoard.Position(row: 6,col: 5)!: ChessPiece(color: ChessPiece.ChessPieceColor.White),
        ChessBoard.Position(row: 6,col: 6)!: ChessPiece(color: ChessPiece.ChessPieceColor.White),
        ChessBoard.Position(row: 6,col: 7)!: ChessPiece(color: ChessPiece.ChessPieceColor.White),
        ChessBoard.Position(row: 7,col: 0)!: ChessPiece(color: ChessPiece.ChessPieceColor.White),
        ChessBoard.Position(row: 7,col: 1)!: ChessPiece(color: ChessPiece.ChessPieceColor.White),
        ChessBoard.Position(row: 7,col: 2)!: ChessPiece(color: ChessPiece.ChessPieceColor.White),
        ChessBoard.Position(row: 7,col: 3)!: ChessPiece(color: ChessPiece.ChessPieceColor.White),
        ChessBoard.Position(row: 7,col: 4)!: ChessPiece(color: ChessPiece.ChessPieceColor.White),
        ChessBoard.Position(row: 7,col: 5)!: ChessPiece(color: ChessPiece.ChessPieceColor.White),
        ChessBoard.Position(row: 7,col: 6)!: ChessPiece(color: ChessPiece.ChessPieceColor.White),
        ChessBoard.Position(row: 7,col: 7)!: ChessPiece(color: ChessPiece.ChessPieceColor.White)
    ]
    
    //MARK: - Properties
    var colorWhoseTurnIs: ChessPiece.ChessPieceColor {
        return _colorWhoseTurnIs
    }
    private var _colorWhoseTurnIs: ChessPiece.ChessPieceColor = ChessPiece.ChessPieceColor.White
    
    private var chessBoard = ChessBoard() //no pieces placed initially
    
    //MARK: - Methods
    
    func movePiece(from oldPosition: ChessBoard.Position, to newPosition: ChessBoard.Position)->Bool {
        
        //check if there is even a piece to move at the oldPosition
        guard let pieceToMove = chessBoard[oldPosition.row,oldPosition.col] else { return false }
        //check if it is the appropriate color, 
        //i.e. it is that colors turn to move
        guard pieceToMove.color == colorWhoseTurnIs else { return false }
        //verify the newPosition is unoccupied or occupied by a piece of different color
        if let pieceToEat = chessBoard[newPosition.row,newPosition.col], pieceToEat.color == pieceToMove.color{
            return false
        }
        //move the piece in the chessboard
        let (pieceWasMoved, pieceEaten) = chessBoard.movePiece(from: oldPosition, to: newPosition)
        if pieceWasMoved{
            print(chessBoard.description)
            _colorWhoseTurnIs.alternate()
            return true
        } else{
            print("Piece unexpectedly could not be moved!")
            return false
        }
        
    }
    
    func PlacePiecesInInitialPositions(){
        let whiteRowRange = 0...1
        let blackRowRange = 6...7
        for row in [whiteRowRange, blackRowRange].joined(){
            for col in 0..<ChessBoardView.Dimensions.SquaresPerRow{
                if let position = ChessBoard.Position(row:row,col:col){
                    _ = chessBoard.set(piece: ChessGame.pieceInitiallyAt[position], at: position)
                }
            }
        }

    }
    
}
