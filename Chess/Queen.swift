//
//  Queen.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-15.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class Queen:CodeableChessPiece, ChessPiece{
    //MARK: - Type Properties
    static var typeId: ChessPieceType = .Queen
    
    //MARK: - Properties
    //MARK: Constants
    let value = 9
    let canJumpOverOtherPieces = false
    let typeId: ChessPieceType = Queen.typeId
    //MARK: - Computed Properties
    var reachableSquares: Set<Position> {
        var reachableSquares = Set<Position>()
        reachableSquares += position.squaresOnSameRow + position.squaresOnSameColumn + position.squaresOnSameDiagonal - [position]
        return reachableSquares
    }
    
    //MARK: Methods
    func isValidMove(to newPosition:Position)->Bool {
        //make sure the queen is moving along the same row, column or diagonal
        guard   nil != position.isOnSameRow(as: newPosition) ||
                nil != position.isOnSameColumn(as: newPosition) ||
                nil != position.isOnSameDiagonal(as: newPosition) else {return false}
        //otherwiseMove is Legal
        return true
    }
    
}
