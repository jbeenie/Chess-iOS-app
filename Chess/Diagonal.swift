//
//  Diagonal.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-04-05.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

//MARK: DIAGONAL
struct Diagonal{
    //MARK: Properties
    let position: Position
    let direction: Direction
    
    //MARK: NestedType
    enum Direction {
        case toTopRight
        case toTopLeft
    }
    
    //MARK: Static Methods
    
    //returns a position on the board on the specified diagonal and column
    static func positionOn(_ diagonal: Diagonal, andColumn col: Int)->Position?{
        //validate the col parameter
        guard Position.validColRange.contains(col) else {return nil}
        //calculate rowOffset
        let rowOffSet = diagonal.position.col - col
        //add or substract rowOffset depending on relative positioning
        let row = diagonal.position.row + ((diagonal.direction == .toTopLeft) ? -rowOffSet : rowOffSet)
        return Position(row: row, col: col)
    }
    
    //MARK: Initializers
    
    init(position: Position, direction: Direction){
        self.direction = direction
        self.position = position
    }
    //convenience initializer that attempts to create a diagonal
    //passing through both positions
    //the initializer fails if the positions do not share a common diagonal
    //or if both positions are equal as the direction of the diagonal
    //is ambiguous in this case
    init?(position1: Position, position2: Position){
        //make sure both positions are on same diagonal
        //and positions are not the same
        //otherwise initializer fails
        guard   position1 != position2 &&
            position1.isOnSameDiagonal(as: position2) != nil else {return nil}
        let direction: Direction
        if position1.row > position2.row{
            direction = position1.col > position2.col ? .toTopLeft : .toTopRight
        }else{
            direction = position1.col < position2.col ? .toTopLeft : .toTopRight
        }
        self.init(position: position1, direction: direction)
    }
    //MARK: Debugging
    var description:String{
        return "Diagonal with position: \(position) and direction: \(direction)"
    }
    
}
