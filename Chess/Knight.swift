//
//  Knight.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-15.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class Knight:CodeableChessPiece, ChessPiece{
    //MARK: - Type Properties
    static var typeId:ChessPieceType = .Knight
    
    //MARK: - Properties
    //MARK: Constants
    let value = 3
    let canJumpOverOtherPieces = true
    let typeId: ChessPieceType = Knight.typeId
    //MARK: - Computed Properties
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

}
