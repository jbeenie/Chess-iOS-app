//
//  Position.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-04-05.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation


struct Position: Hashable, Equatable{
    //MARK: Constants
    static let validRowRange = (0..<ChessBoard.Dimensions.SquaresPerRow)
    static let validColRange = (0..<ChessBoard.Dimensions.SquaresPerColumn)
    static let columnLetters = [0:"A",1:"B",2:"C",3:"D",4:"E",5:"F",6:"G",7:"H"]
    
    //MARK: Static Methods
    static func isValidRow(_ row: Int)->Bool{
        return validRowRange.contains(row)
    }
    
    static func isValidColumn(_ col: Int)->Bool{
        return validColRange.contains(col)
    }
    
    //MARK: Stored Varialbes
    let (row,col): (Int, Int)
    
    //MARK: Computed Variables
    var adjacentSquares: Set<Position> {
        var adjacentSquares = Set<Position>()
        for rowOffSet in -1...1{
            for colOffSet in -1...1{
                if let adjacentSquare = Position(row: self.row + rowOffSet, col: self.col + colOffSet){
                    if adjacentSquare != self{
                        adjacentSquares.insert(adjacentSquare)
                    }
                }
            }
        }
        return adjacentSquares
    }
    
    var squaresOnSameRow:Set<Position>{
        var squaresOnSameRow = Set<Position>()
        for col in Position.validColRange{
            squaresOnSameRow.insert(Position(row: self.row, col: col)!)
        }
        return squaresOnSameRow
    }
    
    var squaresOnSameColumn:Set<Position>{
        var squaresOnSameColumn = Set<Position>()
        for row in Position.validRowRange{
            squaresOnSameColumn.insert(Position(row: row, col: self.col)!)
        }
        return squaresOnSameColumn
    }
    
    var squaresOnSameDiagonal:Set<Position>{
        var squaresOnSameDiagonal = Set<Position>()
        for row in Position.validRowRange{
            let col1 = self.col + abs(row-self.row)
            let col2 = self.col - abs(row-self.row)
            if let position1 = Position(row: row, col: col1){
                squaresOnSameDiagonal.insert(position1)
                
            }
            if let position2 = Position(row: row, col: col2){
                squaresOnSameDiagonal.insert(position2)
            }
        }
        return squaresOnSameDiagonal
    }
    
    var squareswithLRelativePosition:Set<Position>{
        var squareswithLRelativePosition = Set<Position>()
        for rowOffSet in [(-2)...(-1), 1...2].joined() {
            let colOffSet = (abs(rowOffSet) == 2) ? 1: 2
            if let position1 = Position(row: self.row + rowOffSet, col: self.col + colOffSet){
                squareswithLRelativePosition.insert(position1)
            }
            if let position2 = Position(row: self.row + rowOffSet, col: self.col - colOffSet){
                squareswithLRelativePosition.insert(position2)
            }
        }
        return squareswithLRelativePosition
    }
    
    //MARK: Conformance to Hashable Protocol
    var hashValue: Int {
        return row * 10 + col
    }
    
    //MARK: Conformance to Equatable Protocol
    static func == (lhs: Position, rhs: Position) -> Bool {
        return lhs.row == rhs.row && lhs.col == rhs.col
    }
    
    //MARK: Methods
    
    mutating func set(row:Int, col:Int)->Bool{
        if let newPosition = Position(row: row, col: col){
            self = newPosition
            return true
        }
        return false
    }
    
    //returns squares on same row as position
    //that are within the specified columns
    func squaresOnSameRowWithin(col1:Int,col2:Int)->[Position]{
        guard Position.validColRange.contains(col1), Position.validColRange.contains(col2) else {return []}
        if col1 == col2 {return [Position(row: row,col: col1)!]}
        let positionsOnSameRow = squaresOnSameRow
        let columnRange = col1 < col2 ?  col1...col2 : col2...col1
        return positionsOnSameRow.filter() {columnRange.contains($0.col)}
    }
    
    //answers whether or not two positions are on the same row
    //if they are it returns an int specifying how far away
    //the other position is along the row, returning 0 if they are the same square
    //returns nil if they are not on the same row
    func isOnSameRow(as position: Position)->Int?{
        guard self.row == position.row else {return nil}
        return abs(self.col - position.col)
    }
    
    //same as isOnSameRow but for columns,
    //isOnSameColumn has the optional parameter 'signed'
    //which when set to true returns a signed integer
    //which serves to indication which position is higher then the other
    func isOnSameColumn(as position: Position, signed:Bool = false)->Int?{
        guard self.col == position.col else {return nil}
        return signed ? self.row - position.row : abs(self.row - position.row)
    }
    
    //Similarly this method tells you if two positions lie along the same diagonal
    //returns nil if it is not
    //returns an unsigned int specifying how far apart the positions
    //returns 0 if they are the same square
    func isOnSameDiagonal(as position: Position,signed:Bool = false)->Int?{
        let intersection = Position(row: self.row, col: position.col)!
        let verticalSpacing = position.isOnSameColumn(as: intersection, signed: signed)!
        let horizontalSpacing = self.isOnSameRow(as: intersection)!
        guard abs(verticalSpacing) == horizontalSpacing else {return nil}
        return signed ? -verticalSpacing : abs(verticalSpacing)
    }
    
    //This method is used for knights movement. It figures out whether the two positions
    //lie within a 3 X 2 rectangle
    func isLPositionedRelative(to position: Position)->Bool{
        let intersection1 = Position(row: self.row, col: position.col)!
        let intersection2 = Position(row: position.row, col: self.col)!
        let verticalSpacing = self.isOnSameColumn(as: intersection2)
        let horizontalSpacing  = self.isOnSameRow(as: intersection1)
        if  (verticalSpacing == 1 && horizontalSpacing == 2) ||
            (verticalSpacing == 2 && horizontalSpacing == 1){
            return true
        }
        return false
    }
    
    //MARK: Initializers
    init?(row: Int, col: Int){
        (self.row,self.col) = (row,col)
        if !isValidPosition(){ return nil}
    }
    
    //helper method used by initializer to determine success of initilization
    private func isValidPosition()->Bool{
        return  Position.isValidRow(self.row) &&
            Position.isValidColumn(self.col)
    }
    
    //MARK: Debugging
    //description style like A3 or E5
    var description: String{
        return "(\(Position.columnLetters[col]!),\(8-row))"
    }
}

extension Position{
    func propertyList() -> Any {
        let plist:[String:Int] = ["row": row,"col":col]
        return plist
    }
    
    init?(propertyList: Any?) {
        guard let dataDictionary = propertyList as? [String:Int] else {return nil}
        guard let row = dataDictionary["row"], let col = dataDictionary["col"]
            else {return nil}
        self.init(row: row, col: col)
    }
    
}
