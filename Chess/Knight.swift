//
//  Knight.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-15.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class Knight: ChessPiece{
    //MARK: - Properties
    //MARK: Constants
    let color: ChessPieceColor
    let value = 3
    let canJumpOverOtherPieces = true
    let typeId: String = "H"
    //MARK: Variables
    var position: Position? = nil
    var hasMoved: Bool = false
    var chessBoard: ChessBoard? = nil
    
    //MARK: Methods
    func isValidMove(to newPosition:Position)->Bool {
        //make sure the knight is on the board
        guard let position = self.position else {return false}
        //make sure Knight is moving to position that is L positioned relative to it
        guard position.isLPositionedRelative(to: newPosition) else {return false}
        //otherwiseMove is Legal
        return true
    }
    
    
    //MARK: - Initializers
    required init(color: ChessPieceColor, position:Position? = nil, chessBoard:ChessBoard?=nil){
        self.color = color
        self.position = position
        self.chessBoard = chessBoard
    }
    
    required init(chessPiece: ChessPiece){
        self.color = chessPiece.color
        self.position = chessPiece.position
        self.chessBoard = chessPiece.chessBoard
    }
}
