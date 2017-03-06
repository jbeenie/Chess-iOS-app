//
//  Knight.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-15.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class Knight: ChessPiece{
    //MARK: - Type Properties
    static var typeId = "H"
    
    //MARK: - Properties
    //MARK: Constants
    let color: ChessPieceColor
    let value = 3
    let canJumpOverOtherPieces = true
    let typeId: String = Knight.typeId
    //MARK: Variables
    let initialPosition: Position
    var position: Position
    var hasMoved: Bool = false
    var chessBoard: ChessBoard
    var reachableSquares: Set<Position> {
        var reachableSquares = Set<Position>()
        reachableSquares += position.squareswithLRelativePosition
        return reachableSquares
    }
    
    //MARK: Methods
    func isValidMove(to newPosition:Position)->Bool {
        //make sure Knight is moving to position that is L positioned relative to it
        guard position.isLPositionedRelative(to: newPosition) else {return false}
        //otherwiseMove is Legal
        return true
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
