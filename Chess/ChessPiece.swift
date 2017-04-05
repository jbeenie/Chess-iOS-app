//
//  ChessPiece.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-15.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

protocol ChessPiece:class{
    //MARK: - Properties
    var initialPosition: Position {get}
    var position: Position {get set}
    var color: ChessPieceColor {get}
    var value: Int {get}
    var canJumpOverOtherPieces: Bool {get}
    var hasMoved: Bool {get set}
    var typeId: ChessPieceType {get}
    var chessBoard: ChessBoard {get}
    var reachableSquares:Set<Position> {get}
    
    
    
    //MARK: - Methods
    func isValidMove(to newPosition:Position)->Bool
    
    
    
    //MARK: - Initializers
    init(color: ChessPieceColor, position: Position, chessBoard: ChessBoard, hasMoved:Bool)
    
    //used to create new copies of chesspieces on New ChessBoards
    init(chessPiece:ChessPiece, chessBoard:ChessBoard?)
    
}
//MARK: -

extension ChessPiece{
    //MARK:  Debugging
    var description: String{
        return "\(color.rawValue)\(typeId.rawValue)"
    }
    
    //MARK: - Static Properties and Methods
    
    //MARK: Creating ChessPiece from type ID
    
    private static var chessPieceCreators:[ChessPieceType:(ChessPieceColor,Position,ChessBoard)->ChessPiece] {
        return [
        .Pawn: {(color,pos,board) in return Pawn(color:color, position:pos, chessBoard:board,hasMoved:true)},
        .Rook: {(color,pos,board) in return Rook(color:color, position:pos, chessBoard:board,hasMoved:true)},
        .Knight: {(color,pos,board) in return Knight(color:color, position:pos, chessBoard:board,hasMoved:true)},
        .Bishop: {(color,pos,board) in return Bishop(color:color, position:pos, chessBoard:board,hasMoved:true)},
        .Queen: {(color,pos,board) in return Queen(color:color, position:pos, chessBoard:board,hasMoved:true)},
        .King: {(color,pos,board) in return King(color:color, position:pos, chessBoard:board,hasMoved:true)}]
    }
    
    static func createChessPiece(of type:ChessPieceType, color: ChessPieceColor, at position:Position, on chessBoard:ChessBoard)->ChessPiece{
        let chessPieceCreator = chessPieceCreators[type]!
        return chessPieceCreator(color,position,chessBoard)
    }
    
    
    //MARK: - Computed Properties
    //King of that chesspiece
    var king:King?{return color == .White ? chessBoard.whiteKing : chessBoard.blackKing}
    
    //the rank the piece is currently on (takes into account peices color)
    var rank:Int{return (color == .Black ?  position.row + 1 : (ChessBoard.Dimensions.SquaresPerColumn - position.row))}
    
    
    //MARK: - Methods
    //returns the rank the piece would be on if it was on the given position
    func rank(ifAt position:Position)->Int{
        return (color == .Black ?  position.row + 1 : (ChessBoard.Dimensions.SquaresPerColumn - position.row))
    }
    
    func attackingSquare(at targetedPosition: Position)->Bool{
        //make sure targeted position is different from the piece's current position
        guard self.position != targetedPosition else {return false}
        //verify the piece at the targeted position is not another piece of the same color
        if let targetedPiece = chessBoard[targetedPosition.row,targetedPosition.col], targetedPiece.color == self.color{
            return false
        }
        //check if the piece can move in that way
        guard isValidMove(to: targetedPosition) else{return false}
        //check whether or not piece illegally jumps over other peices
        guard !doesPieceIllegalyJumpOverOtherPieceWhenMoving(to: targetedPosition) else {return false}
        return true
    }
    
    //answers whether or not the piece can move to the new position
    //and executes the move if execute is set to true
    //returns a Move if the move can be executed and nil otherwise
    func move(to newPosition: Position, execute:Bool=true)->Move?{
        //verify the piece is attacking the square at the new position
        guard attackingSquare(at: newPosition) else {return nil}
        //need to remember old position of piece after the peice has been moved
        let oldPosition = position
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
        //move the piece bac to its original position
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
enum ChessPieceColor: String {
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

enum ChessPieceType: String{
    case    Pawn = "P",
            Knight = "H",
            Bishop = "B",
            Rook = "R",
            Queen = "Q",
            King = "K"
}

enum Side:String{
    case King = "K", Queen = "Q"
}
