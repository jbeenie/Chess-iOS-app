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
                let chessPieceDescription =  self[row,col]?.description ?? "  "
                description += chessPieceDescription + ","
            }
            description += "\n"
        }
        return description
    }
    
    //MARK: - Initializers
    init() {
    }
    
    convenience init(chessBoard:ChessBoard){
        //first initialize the chessBoard instances
        self.init()
        //place a new copy of each chess piece that was on chessBoard onto the new board
        for row in Position.validRowRange{
            for col in Position.validColRange{
                let position = Position(row: row, col: col)!
                let chessPiece = chessBoard.piece(at: position)
                chessPiece?.chessBoard = self
                _ = self.set(piece: chessPiece, at: position)
            }
        }
    }
    
    //MARK: - Subscripts
    private func indexIsValid(row: Int, column: Int) -> Bool {
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
    
    //MARK: - Methods
    //MARK: Moving, Getting, Placing, Removing Pieces
    
    //Get copy of piece at position
    func piece(at position:Position)->ChessPiece?{
        if let  chessPiece = self[position.row,position.col]{
            return type(of: chessPiece).init(chessPiece: chessPiece)
        }
        return nil
    }
    
    //Moves a piece from oldPosition to newPosition
    //returns a tuple containing a Bool and an optional ChessPieceView
    //the first component (Bool) is true if a piece was infact moved,
    //i.e. if there was a piece at oldPosition
    //the second component (ChessPieceView?) is the piece previously located at newPosition
    //or nil if no piece was there
    func movePiece(from oldPostion: Position, to newPosition: Position)->(Bool, ChessPiece?){
        if let pieceToMove = removePiece(from: oldPostion){
            let pieceEaten = set(piece: pieceToMove, at: newPosition)
            return (true, pieceEaten)
        }
        return (false,nil)
    }
    
   
    
    //Places a piece at the desired position on the board
    //returns the piece that previously occupied that position or nil if no piece was there
    func set(piece: ChessPiece?, at position: Position)->ChessPiece?{
        let replacedPiece = self[position.row,position.col]
        chessBoardSquares[position.row][position.col] = piece
        piece?.chessBoard = self
        return replacedPiece
    }
    
    //attempts to remove a piece from the specified location
    //returns the piece it removed or nil if no piece was located at that square
    func removePiece(from position: Position)->ChessPiece?{
        return set(piece: nil, at: position)
    }
    
    
    
    //MARK: Board Querries
    
    //verify each square along the specified row between the specified columns 
    //is unoccupied by a piece
    //the optional inclusive parameter when set to true checks the extremeties of the row slice
    
    func isRow(_ row:Int, emptyBetweenColumns colIndex1: Int, _ colIndex2: Int, inclusive:Bool = false)->Bool{
        let start = min(colIndex1,colIndex2) + (inclusive ? 0 : 1)
        let end = max(colIndex1,colIndex2) - (inclusive ? 0 : 1)
        guard start <= end else {return true}
        //handle case where range is of length 1 seperately because a==b is not allow for a...b
        if start == end {
            guard self[row,start] == nil else{
                let position = Position(row: row, col: start)
                print("Piece found on row slice at position \(position?.description)")
                return false
            }
            return true
        }
        //otherwise go through the range
        let colRange = start...end
        for col in colRange{
            guard self[row,col] == nil else{
                let position = Position(row: row, col: col)
                print("Piece found on row slice at position \(position?.description)")
                return false
            }
        }
        return true
    }
    
    //verify each square along the specified col between the specified rows
    //is unoccupied by a piece
    //the optional inclusive parameter when set to true checks the extremeties of the column slice
    func isColumn(_ col:Int, emptyBetweenRows rowIndex1: Int, _ rowIndex2: Int, inclusive:Bool = false)->Bool{
        let start = min(rowIndex1,rowIndex2) + (inclusive ? 0 : 1)
        let end = max(rowIndex1,rowIndex2) - (inclusive ? 0 : 1)
        guard start <= end else {return true}
        //handle case where range is of length 1 seperately because a==b is not allow for a...b
        if start == end {
            guard self[start,col] == nil else{
                let position = Position(row: start, col: col)
                print("Piece found on column slice at position \(position?.description)")
                return false
            }
            return true
        }
        //otherwise go through the range
        let rowRange = start...end
        for row in rowRange{
            guard self[row,col] == nil else {
                let position = Position(row: row, col: col)
                print("Piece found on column slice at position \(position?.description)")
                return false
            }
        }
        return true
    }
    
    func isDiagonal(_ diag:Diagonal, emptyBetweenColumns colIndex1: Int, _ colIndex2: Int, inclusive:Bool = false)->Bool{
        let startCol = min(colIndex1,colIndex2) + (inclusive ? 0 : 1)
        let endCol = max(colIndex1,colIndex2) - (inclusive ? 0 : 1)
        guard startCol <= endCol else {return true}
        
        let colRange = startCol...endCol
        guard var startPosition = Diagonal.positionOn(diag, andColumn: startCol) else{return false}
        guard let endPosition = Diagonal.positionOn(diag, andColumn: endCol) else{return false}
        let rowOffSet = (endPosition.row - startPosition.row) > 0 ? 1 : -1
        
        //handle case where range is of length 1 seperately because a==b is not allow for a...b
        if startCol == endCol {
            guard self[startPosition.row,startPosition.col] == nil else{
                let position = Position(row: startPosition.row, col: startPosition.col)
                print("Piece found on diagonal slice at position \(position?.description)")
                return false
            }
            return true
        }
        //otherwise go through the range
        for _ in colRange{
            guard self[startPosition.row,startPosition.col] == nil else {
                let position = Position(row: startPosition.row, col: startPosition.col)
                print("Piece found on diagonal slice at position \(position?.description)")
                return false
            }
            guard startPosition.set(row: startPosition.row + rowOffSet, col: startPosition.col+1) else {
                print("Could not increment to next position in diagonal: (\(startPosition.row+rowOffSet), \(startPosition.col+1))")
                return false
            }
        }
        return true
    }
    
    //returns all the pieces of a given color that are on the board
    func piecesOnBoard(ofColor color:ChessPieceColor)->[ChessPiece]{
        var pieces = [ChessPiece]()
        for row in Position.validRowRange{
            for col in Position.validColRange{
                if let piece = self[row,col], piece.color == color{
                    pieces.append(piece)
                }
            }
        }
        return pieces
    }
    
    //answers whether or not a square is under attack by any piece (occupying a different position) 
    //and that has attackingColor. This is determined by itterating through all pieces
    //on the board of the attackingColor and checking whether or not the piece
    //can move to the specified square or not. To ensure we get the correct answer
    //from pawns, a piece of non-attacking color must occupy the square under consideration
    func isSquareUnderAttack(at position: Position, from attackingColor: ChessPieceColor)->Bool{
        //make a copy of the board and use it for the attack analysis
        let boardCopy = ChessBoard(chessBoard: self)
        ChessBoard.prepare(chessBoard: boardCopy, forAttackAnalysisAt: position, from: attackingColor)
        let potentialAttackers = boardCopy.piecesOnBoard(ofColor: attackingColor)
        //check whether or not the square is under attack by any of the potential attackers
        for potentialAttacker in potentialAttackers{
            if potentialAttacker.move(to: position, execute: false){return true}
        }
        return false
    }
    
    //while checking if the square is under attack
    //we must ensure that the square is temporarily
    //occupied by a piece of non-attacking color
    private static func prepare(chessBoard: ChessBoard, forAttackAnalysisAt position:Position, from attackingColor:ChessPieceColor){
        //place a piece of non-attacking color at the specified position
        let pieceOfNonAttackingColor = Pawn(color: attackingColor.opposite(), position: position, chessBoard: chessBoard)
        _ = chessBoard.set(piece: pieceOfNonAttackingColor, at: position)
    }
    
    
    //answer whether or not a piece is under attack by any piece of opposite color
    func isPieceUnderAttack(chessPiece: ChessPiece)->Bool{
        guard let position = chessPiece.position else{return false}
        let attackingColor = chessPiece.color.opposite()
        return isSquareUnderAttack(at: position, from: attackingColor)
    }
}

//MARK: - Supporting Types
//MARK: POSITION
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
    
    //MARK:Varialbes
    let (row,col): (Int, Int)
    
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
//MARK: DIAGONAL
struct Diagonal{
    //MARK: Properties
    var position: Position
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
