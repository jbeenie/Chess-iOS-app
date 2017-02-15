//
//  ChessBoard.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-15.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class ChessBoard{
    //MARK: Dimensions of Board
    struct Dimensions{
        static let SquaresPerRow = 8
        static let SquaresPerColumn = 8
    }
    
    //MARK: - Properties
    private var chessBoardSquares: [[ChessPiece?]] = {
        //create empty board, i.e. with no pieces
        var emptyBoard = [[ChessPiece?]](repeating: [ChessPiece?](), count: Dimensions.SquaresPerColumn)
        for i in Position.validColRange{
            emptyBoard[i] = [ChessPiece?](repeating: nil, count: Dimensions.SquaresPerRow)
        }
        return emptyBoard
    }()
    
    var description: String{
        var description = ""
        for row in Position.validRowRange{
            for col in Position.validColRange{
                let chessPieceDescription =  self[row,col]?.description ?? " "
                description += chessPieceDescription + ","
            }
            description += "\n"
        }
        return description
    }
    
    //MARK: - Subscripts
    func indexIsValid(row: Int, column: Int) -> Bool {
        return  row >= 0 &&
            row < Dimensions.SquaresPerRow &&
            column >= 0 &&
            column < Dimensions.SquaresPerColumn
    }
    
    subscript(row: Int, col: Int) -> ChessPiece? {
        get {
            assert(indexIsValid(row: row, column: col), "Index out of range")
            return chessBoardSquares[row][col]
        }
    }
    
    //MARK: - Moving Pieces
    
    //Moves a piece from oldPosition to newPosition
    //returns a tuple containing a Bool and an optional ChessPieceView
    //the first component (Bool) is true if a piece was infact moved,
    //i.e. if there was a piece at oldPosition
    //the second component (ChessPieceView?) is the piece previously located at newPosition
    //or nil if no piece was there
    func movePiece(from oldPostion: ChessBoard.Position, to newPosition: ChessBoard.Position)->(Bool, ChessPiece?){
        if let pieceToMove = removePiece(from: oldPostion){
            let pieceEaten = set(piece: pieceToMove, at: newPosition)
            return (true, pieceEaten)
        }
        return (false,nil)
        
    }
    
   
    
    //Places a piece at the desired position on the board
    //returns the piece that previously occupied that position or nil if no piece was there
    func set(piece: ChessPiece?, at position: ChessBoard.Position)->ChessPiece?{
        let replacedPiece = self[position.row,position.col]
        chessBoardSquares[position.row][position.col] = piece
        return replacedPiece
    }
    
    //attempts to remove a piece from the specified location
    //returns the piece it removed or nil if no piece was located at that square
    func removePiece(from position: ChessBoard.Position)->ChessPiece?{
        return set(piece: nil, at: position)
    }
    
    //MARK: - Nested Types
    struct Position: Hashable, Equatable{
        static let validRowRange = (0..<ChessBoard.Dimensions.SquaresPerRow)
        static let validColRange = (0..<ChessBoard.Dimensions.SquaresPerColumn)
        static let columnLetters = [0:"A",1:"B",2:"C",3:"D",4:"E",5:"F",6:"G",7:"H"]
        var (row,col): (Int, Int)
        
        var hashValue: Int {
            return row * 10 + col
        }
        
        //description style like A3 or E5
        var description: String{
            return "(\(Position.columnLetters[col]!),\(8-row))"
        }
        
        static func == (lhs: Position, rhs: Position) -> Bool {
            return lhs.row == rhs.row && lhs.col == rhs.col
        }
        
        private func isValidPosition()->Bool{
            return  Position.validRowRange.contains(self.row) &&
                Position.validColRange.contains(self.col)
        }
        
        init?(row: Int, col: Int){
            (self.row,self.col) = (row,col)
            if !isValidPosition(){ return nil}
        }
    }
}
