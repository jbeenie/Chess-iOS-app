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
    var initialPiecePositions: [Position:ChessPiece]{
        return [
            //Initial position of Black Pieces
            Position(row: 0,col: 0)!: Rook(color: ChessPieceColor.Black, position:Position(row: 0,col: 0)!, chessBoard:chessBoard),
            Position(row: 0,col: 1)!: Knight(color: ChessPieceColor.Black, position:Position(row: 0,col: 1)!, chessBoard:chessBoard),
            Position(row: 0,col: 2)!: Bishop(color: ChessPieceColor.Black, position:Position(row: 0,col: 2)!, chessBoard:chessBoard),
            Position(row: 0,col: 3)!: Queen(color: ChessPieceColor.Black, position:Position(row: 0,col: 3)!, chessBoard:chessBoard),
            Position(row: 0,col: 4)!: King(color: ChessPieceColor.Black, position:Position(row: 0,col: 4)!, chessBoard:chessBoard),
            Position(row: 0,col: 5)!: Bishop(color: ChessPieceColor.Black, position:Position(row: 0,col: 5)!, chessBoard:chessBoard),
            Position(row: 0,col: 6)!: Knight(color: ChessPieceColor.Black, position:Position(row: 0,col: 6)!, chessBoard:chessBoard),
            Position(row: 0,col: 7)!: Rook(color: ChessPieceColor.Black, position:Position(row: 0,col: 7)!, chessBoard:chessBoard),
            Position(row: 1,col: 0)!: Pawn(color: ChessPieceColor.Black, position:Position(row: 1,col: 0)!, chessBoard:chessBoard),
            Position(row: 1,col: 1)!: Pawn(color: ChessPieceColor.Black, position:Position(row: 1,col: 1)!, chessBoard:chessBoard),
            Position(row: 1,col: 2)!: Pawn(color: ChessPieceColor.Black, position:Position(row: 1,col: 2)!, chessBoard:chessBoard),
            Position(row: 1,col: 3)!: Pawn(color: ChessPieceColor.Black, position:Position(row: 1,col: 3)!, chessBoard:chessBoard),
            Position(row: 1,col: 4)!: Pawn(color: ChessPieceColor.Black, position:Position(row: 1,col: 4)!, chessBoard:chessBoard),
            Position(row: 1,col: 5)!: Pawn(color: ChessPieceColor.Black, position:Position(row: 1,col: 5)!, chessBoard:chessBoard),
            Position(row: 1,col: 6)!: Pawn(color: ChessPieceColor.Black, position:Position(row: 1,col: 6)!, chessBoard:chessBoard),
            Position(row: 1,col: 7)!: Pawn(color: ChessPieceColor.Black, position:Position(row: 1,col: 7)!, chessBoard:chessBoard),
            //Initial position of White Pieces
            Position(row: 6,col: 0)!: Pawn(color: ChessPieceColor.White, position:Position(row: 6,col: 0)!, chessBoard:chessBoard),
            Position(row: 6,col: 1)!: Pawn(color: ChessPieceColor.White, position:Position(row: 6,col: 1)!, chessBoard:chessBoard),
            Position(row: 6,col: 2)!: Pawn(color: ChessPieceColor.White, position:Position(row: 6,col: 2)!, chessBoard:chessBoard),
            Position(row: 6,col: 3)!: Pawn(color: ChessPieceColor.White, position:Position(row: 6,col: 3)!, chessBoard:chessBoard),
            Position(row: 6,col: 4)!: Pawn(color: ChessPieceColor.White, position:Position(row: 6,col: 4)!, chessBoard:chessBoard),
            Position(row: 6,col: 5)!: Pawn(color: ChessPieceColor.White, position:Position(row: 6,col: 5)!, chessBoard:chessBoard),
            Position(row: 6,col: 6)!: Pawn(color: ChessPieceColor.White, position:Position(row: 6,col: 6)!, chessBoard:chessBoard),
            Position(row: 6,col: 7)!: Pawn(color: ChessPieceColor.White, position:Position(row: 6,col: 7)!, chessBoard:chessBoard),
            Position(row: 7,col: 0)!: Rook(color: ChessPieceColor.White, position:Position(row: 7,col: 0)!, chessBoard:chessBoard),
            Position(row: 7,col: 1)!: Knight(color: ChessPieceColor.White, position:Position(row: 7,col: 1)!, chessBoard:chessBoard),
            Position(row: 7,col: 2)!: Bishop(color: ChessPieceColor.White, position:Position(row: 7,col: 2)!, chessBoard:chessBoard),
            Position(row: 7,col: 3)!: Queen(color: ChessPieceColor.White, position:Position(row: 7,col: 3)!, chessBoard:chessBoard),
            Position(row: 7,col: 4)!: King(color: ChessPieceColor.White, position:Position(row: 7,col: 4)!, chessBoard:chessBoard),
            Position(row: 7,col: 5)!: Bishop(color: ChessPieceColor.White, position:Position(row: 7,col: 5)!, chessBoard:chessBoard),
            Position(row: 7,col: 6)!: Knight(color: ChessPieceColor.White, position:Position(row: 7,col: 6)!, chessBoard:chessBoard),
            Position(row: 7,col: 7)!: Rook(color: ChessPieceColor.White, position:Position(row: 7,col: 7)!, chessBoard:chessBoard)
        ]
    }
    
    
    //MARK: - Properties
    //game is started if any piece has moved
    var started:Bool{
        for piece in chessBoard.pieces(){
            if piece.hasMoved{return true}
        }
        return false
    }
    var ended:Bool{
        return outCome == nil ? false : true
    }
    //returns the outcome of the game if it has ended or nil if the game is still in session
    var outCome:OutCome?{
        if noPieceCanMove(in: chessBoard.pieces(ofColor: colorWhoseTurnItIs)){
            return (activeKingInCheck ? OutCome.Win(colorWhoseTurnItIs.opposite()) : OutCome.Draw)
        }
        return nil
    }

    var colorWhoseTurnItIs: ChessPieceColor {
        return _colorWhoseTurnItIs
    }
    private var _colorWhoseTurnItIs: ChessPieceColor = ChessPieceColor.White
    
    private var chessBoard = ChessBoard() //no pieces placed initially
    private var moves:[Move] = [Move]()
    
    //King Related
    private var whiteKing: King?{return chessBoard.whiteKing}
    private var blackKing: King?{return chessBoard.blackKing}
    private var activeKing: King?{
        return colorWhoseTurnItIs == .White ? whiteKing : blackKing
    }
    private var nonActiveKing:King?{
        return colorWhoseTurnItIs == .White ? blackKing : whiteKing
    }
    private var activeKingInCheck: Bool{
        return activeKing?.isInCheck() ?? false
    }
    private var nonActiveKingInCheck: Bool{
        return nonActiveKing?.isInCheck() ?? false
    }

    
    //MARK: - Methods
    
    func piece(at position:Position)->ChessPiece?{
        return chessBoard.piece(at: position)
    }
    
    //attempts to move a piece from oldPosition to new position
    //returns:
    //1. Bool indicating whether move is successcul and executed
    //2. Bool indicating whether move leaves opponents king in check
    //3. OutCome? indicating if game is ended and what the outcome is so
    //
    //move is successful if:
    //  1.The piece can move in that way
    //  2.The acting piece's king is not left in check as a result of the move
    func movePiece(from oldPosition: Position, to newPosition: Position)->(Bool,Bool?,OutCome?) {
        //check if game is ended
        guard !ended else{return (false,nil,nil)}
        //check if there is even a piece to move at the oldPosition
        guard let pieceToMove = chessBoard[oldPosition.row,oldPosition.col] else { return (false,nil,nil) }
        //check if it is the appropriate color, 
        //i.e. it is that colors turn to move
        guard pieceToMove.color == colorWhoseTurnItIs else { return (false,nil,nil) }
        
        //ask the piece to move itself to the new position and check if the move succeeds
        //this updates the piece's position on the board and within its own class
        
        //Type cast ChessPiece to King if pieceToMove is a King
        //to handle castling seperately
        let move:Move?
        if let king = pieceToMove as? King{
            move = king.move(to: newPosition)
        }else{
            move = pieceToMove.move(to: newPosition)
        }
        guard move != nil  else {
            return (false,nil,nil)
        }
        
        //record themove
        moves.append(move!)
        
        //debugging
        print(chessBoard.description)
        //next players turn (always do this last)
        _colorWhoseTurnItIs.alternate()
        
        //indicate if move succeeded
        //if king whosTurnItIs is in check
        //if game is ended
        return (true, activeKingInCheck, outCome)
    }
    
    //undoes the last move in the game and returns the move that was undone
    func undoLastMove()->Move?{
        //check if there are any moves to undo
        guard let lastMove = moves.popLast() else {return nil}
        //get the last piece moved
        guard let lastPieceMoved = chessBoard[lastMove.endPosition.row,lastMove.endPosition.col] else
        {return nil}
        //undo the last move
        guard lastPieceMoved.undo(move: lastMove) else {
            print("Error: piece could not be moved back to previous position")
            return nil
        }
        print(chessBoard.description)//debugging
        _colorWhoseTurnItIs.alternate()
        return lastMove
    }
    
    
    func PlacePiecesInInitialPositions(){
        chessBoard.placePieces(at: initialPiecePositions)
    }
    
    //MARK: - Private Methods
    
    private func noPieceCanMove(in chessPieces: [ChessPiece])->Bool{
        for piece in chessPieces{
            if piece.canMove() {return false}
        }
        return true
    }
}

//MARK: - Supporting Type



enum OutCome{
    case Win(ChessPieceColor)
    case Draw
}
