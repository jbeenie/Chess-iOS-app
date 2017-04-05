//
//  ChessBoard.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-15.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class ChessBoard:NSObject,NSCoding{
    //MARK: Dimensions of Board
    struct Dimensions{
        static let SquaresPerRow = 8
        static let SquaresPerColumn = 8
    }
    
    //MARK: - Stored Properties
    private var chessBoardSquares: [[ChessPiece?]] = {
        //create empty board, i.e. with no pieces
        var emptyChessBoardSquares = [[ChessPiece?]](repeating: [ChessPiece?](), count: Dimensions.SquaresPerColumn)
        for i in Position.validColRange{
            emptyChessBoardSquares[i] = [ChessPiece?](repeating: nil, count: Dimensions.SquaresPerRow)
        }
        return emptyChessBoardSquares
    }()
    
    
    private var _whiteKing: King? = nil
    private var _blackKing: King? = nil
    
    //MARK: - Computed Properties
    override var description: String{
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
    //pointers to kings for easy access
    var whiteKing:King?{return _whiteKing}
    var blackKing:King?{return _blackKing}
    
    //MARK: - Initializers
    
    
    //creates a copy of a chessBoard
    convenience init(chessBoard:ChessBoard){
        //first initialize the chessBoard instance
        self.init()
        //place a new copy of each chess piece that was on chessBoard onto the new board
        for row in Position.validRowRange{
            for col in Position.validColRange{
                let position = Position(row: row, col: col)!
                if let chessPiece = chessBoard.piece(at: position, placeOnBoard: self){//associated to old board
                    _ = self.set(piece: chessPiece, at: position)
                }
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
    
    //Get copy of piece at a position which is associated to the same board
    func piece(at position:Position, placeOnBoard chessBoard:ChessBoard? = nil)->ChessPiece?{
        if let  chessPiece = self[position.row,position.col]{
            return type(of: chessPiece).init(chessPiece: chessPiece,chessBoard: (chessBoard ?? self))
        }
        return nil
    }
    //method used to place pieces on the board when
    //does not necessarily need to place the pieces in their initial positions
    //takes in a dictionary mapping positions to pieces non optional pieces
    //wires up the pointers to the kings
    func placePieces(at positions: [Position:ChessPiece]){
        for (position, pieceToPlace) in positions{
            _ = self.set(piece: pieceToPlace, at: position)
            //hook up the the pointers to kings
            if let king = pieceToPlace as? King{
                if pieceToPlace.color == .White{_whiteKing = king}
                else if pieceToPlace.color == .Black{_blackKing = king}
            }
        }
    }
    
    //Moves a piece from oldPosition to newPosition
    //returns a tuple containing a Bool and an optional ChessPieceView
    //the first component (Bool) is true if a piece was infact moved,
    //i.e. if there was a piece at oldPosition
    //the second component (ChessPieceView?) is the piece previously located at newPosition
    //or nil if no piece was there
    func movePiece(from oldPostion: Position, to newPosition: Position,execute:Bool=true)->(Bool, ChessPiece?){
        if let pieceToMove = removePiece(from: oldPostion, execute: execute){
            let pieceEaten = set(piece: pieceToMove, at: newPosition, execute: execute)
            return (true, pieceEaten)
        }
        return (false,nil)
    }
    
   
    
    //Places a piece at the desired position on the board
    //returns the piece that previously occupied that position or nil if no piece was there
    func set(piece: ChessPiece?, at position: Position, execute:Bool=true)->ChessPiece?{
        //verify piece is associated to this board
        if let piece = piece, piece.chessBoard  !== self {
            return nil
        }
        let replacedPiece = self[position.row,position.col]
        //if execute is false simply return the piece that would be replaced if any
        guard execute else{return replacedPiece}
        chessBoardSquares[position.row][position.col] = piece
        //update pieces position, board
        piece?.position = position
        return replacedPiece
    }
    
    //attempts to remove a piece from the specified location
    //returns the piece it removed or nil if no piece was located at that square
    func removePiece(from position: Position, execute:Bool=true)->ChessPiece?{
        return set(piece: nil, at: position,execute: execute)
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
                _ = Position(row: row, col: start)
                //print("Piece found on row slice at position \(position?.description)")
                return false
            }
            return true
        }
        //otherwise go through the range
        let colRange = start...end
        for col in colRange{
            guard self[row,col] == nil else{
                _ = Position(row: row, col: col)
                //print("Piece found on row slice at position \(position?.description)")
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
                _ = Position(row: start, col: col)
                //print("Piece found on column slice at position \(position?.description)")
                return false
            }
            return true
        }
        //otherwise go through the range
        let rowRange = start...end
        for row in rowRange{
            guard self[row,col] == nil else {
                _ = Position(row: row, col: col)
                //print("Piece found on column slice at position \(position?.description)")
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
                _ = Position(row: startPosition.row, col: startPosition.col)
                //print("Piece found on diagonal slice at position \(position?.description)")
                return false
            }
            return true
        }
        //otherwise go through the range
        for _ in colRange{
            guard self[startPosition.row,startPosition.col] == nil else {
                _ = Position(row: startPosition.row, col: startPosition.col)
                //print("Piece found on diagonal slice at position \(position?.description)")
                return false
            }
            guard startPosition.set(row: startPosition.row + rowOffSet, col: startPosition.col+1) else {
                //print("Could not increment to next position in diagonal: (\(startPosition.row+rowOffSet), \(startPosition.col+1))")
                return false
            }
        }
        return true
    }
    
    //returns all the pieces of a given color on the board
    func pieces(ofColor color:ChessPieceColor)->[ChessPiece]{
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
    
    //returns all the pieces on the board
    func pieces()->[ChessPiece]{
        return pieces(ofColor: ChessPieceColor.White) + pieces(ofColor: ChessPieceColor.Black)
    }
    
    func areAnySquaresUnderAttck(at positions: [Position], from attackingColor: ChessPieceColor)->Bool{
        for position in positions{
            if squareUnderAttack(at: position, from: attackingColor){return true}
        }
        return false
    }
    
    //answers whether or not a square is under attack by any piece (occupying a different position) 
    //and that has attackingColor. This is determined by itterating through all pieces
    //on the board of the attackingColor and checking whether or not the piece
    //can move to the specified square or not. To ensure we get the correct answer
    //from pawns, a piece of non-attacking color must occupy the square under consideration
    func squareUnderAttack(at position: Position, from attackingColor: ChessPieceColor)->Bool{
        var boardOnWhichToPerformAttackAnalysis:ChessBoard
        //****************OPTIMIZATION*****************
        //check whether or not the square under consideration
        //is occupied by a piece of non-attacking color
        if let colorOfAttackedPiece = self[position.row,position.col]?.color, colorOfAttackedPiece == attackingColor.opposite(){
            //if it is then just use the board recieving the querry
            boardOnWhichToPerformAttackAnalysis = self
        }else{
            //if it is not make a copy of the board and use it for the attack analysis
            boardOnWhichToPerformAttackAnalysis = ChessBoard(chessBoard: self)
            ChessBoard.prepare(chessBoard: boardOnWhichToPerformAttackAnalysis, forAttackAnalysisAt: position, from: attackingColor)
        }
        //**********************************************

        //perform attack analysis
        let potentialAttackers = boardOnWhichToPerformAttackAnalysis.pieces(ofColor: attackingColor)
        //check whether or not the square is under attack by any of the potential attackers
        for potentialAttacker in potentialAttackers{
            if potentialAttacker.attackingSquare(at: position){return true}
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
    func pieceUnderAttack(chessPiece: ChessPiece)->Bool{
        let attackingColor = chessPiece.color.opposite()
        return squareUnderAttack(at: chessPiece.position, from: attackingColor)
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(chessBoardSquares, forKey: "chessBoardSquares")
        //FIXME: - Pack Position into NSDictionary
        aCoder.encode(_whiteKing?.position, forKey: "whiteKing.position")
        aCoder.encode(_blackKing?.position, forKey: "blackKing.position")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let chessBoardSquares = aDecoder.decodeObject(forKey: "chessBoardSquares") as? [[ChessPiece?]]
            else{return nil}
        //FIXME: - Unpack NSDictionary into Position
        let whiteKingPosition = aDecoder.decodeObject(forKey: "whiteKing.position") as? Position
        let blackKingPosition = aDecoder.decodeObject(forKey: "blackKing.position") as? Position
        
        self.init()
        self.chessBoardSquares = chessBoardSquares
        if whiteKingPosition != nil{
            self._whiteKing = (self[whiteKingPosition!.row,whiteKingPosition!.col] as! King)
        }
        if blackKingPosition != nil{
            self._blackKing = (self[blackKingPosition!.row,blackKingPosition!.col] as! King)
        }
    }

}
