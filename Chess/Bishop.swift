//
//  Bishop.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-15.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class Bishop:CodeableChessPiece, ChessPiece{
    //MARK: - Type Properties
    static var typeId:ChessPieceType = .Bishop
    
    //MARK: - Properties
    //MARK: Constants
    let value = 3
    let canJumpOverOtherPieces = false
    let typeId:ChessPieceType = Bishop.typeId
    //MARK: - Computed Properties
    var reachableSquares: Set<Position> {
        var reachableSquares = Set<Position>()
        reachableSquares += position.squaresOnSameDiagonal - [position]
        return reachableSquares
    }
    
    //MARK: Methods
    func isValidMove(to newPosition:Position)->Bool {
        //make sure bishop is moving along the same diagonal
        guard let _ = position.isOnSameDiagonal(as: newPosition) else {return false}
        //otherwiseMove is Legal
        return true
    }
}
