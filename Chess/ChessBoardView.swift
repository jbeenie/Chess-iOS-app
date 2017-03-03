//
//  ChessBoard.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-11.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class ChessBoardView: UIView {
    //MARK: - Constants
    
    //MARK: Defaults
    struct Default{
        static let colorOfWhiteSquares = UIColor.white
        static let colorOfBlackSquares = UIColor.gray
        static let colorOfSelectedBlackSquares = UIColor.blue
        static let alphaOfSelectedWhiteSquares: CGFloat = 0.5
    }
    
    //MARK: Dimensions of Board
    struct Dimensions{
        static let SquaresPerRow = 8
        static let SquaresPerColumn = 8
    }
    
    //MARK: - Variables
    //MARK: Colors of board
    
    var colorOfWhiteSquares: UIColor
    var colorOfBlackSquares: UIColor
    var colorOfSelectedBlackSquares: UIColor
    var drawIndices: Bool = true
    
    var isSetUp = false
    
    var colorOfSelectedWhiteSquares: UIColor{
        return (colorOfSelectedBlackSquares.copy() as! UIColor).withAlphaComponent(Default.alphaOfSelectedWhiteSquares)
    }
    
    //MARK: - Helper methods
    func centerOfSquare(at position: ChessBoardView.Position)->CGPoint{
        return self[position.row,position.col].center
    }
    
    //MARK: - Subviews
    //MARK: ChessBoard square array
    lazy private var chessBoardSquares: [[ChessBoardSquareView]] = self.setUpChessBoardSquares()
    
    //helper method used to setup the chessboard square array
    private func setUpChessBoardSquares() -> [[ChessBoardSquareView]] {
        var chessBoardSquares = [[ChessBoardSquareView]]()
        var isBlack = false
        for row in 0..<Dimensions.SquaresPerRow {
            chessBoardSquares.append(Array<ChessBoardSquareView>())
            for col in 0..<Dimensions.SquaresPerColumn {
                //set up chess board square initialization parameters
                let color = isBlack ? colorOfBlackSquares : colorOfWhiteSquares
                let selectedColor = isBlack ? colorOfSelectedBlackSquares : colorOfSelectedWhiteSquares
                let sideLength: CGFloat = min(bounds.height, bounds.width)/8
                let size = CGSize(width: sideLength, height: sideLength)
                let origin = CGPoint(x: sideLength*CGFloat(col), y: sideLength*CGFloat(row))
                let frame = CGRect(origin: origin, size: size)
                
                //initialize chessboard square
                if let chessBoardSquare = ChessBoardSquareView(frame: frame, color: color, selectedColor: selectedColor){
                    //set position of chess board square
                    chessBoardSquare.position = Position(row: row, col: col)
                    chessBoardSquares[row].append(chessBoardSquare)
                }else {
                    print("Selected Color: \(selectedColor) cannot be the same as (unselected) color \(color)")
                }
                
                
                isBlack = !isBlack
            }
            isBlack = !isBlack
        }
        return chessBoardSquares
    }
    
    //method used to add chess square subviews to chessboard
    func setUpChessBoardView(){
        for row in 0..<Dimensions.SquaresPerRow {
            for col in 0..<Dimensions.SquaresPerColumn {
                addSubview(chessBoardSquares[row][col])
            }
        }
        if drawIndices{setUpChessBoardIndices()}
        isSetUp = true
    }
    
    //MARK: Drawing Indices
    struct ChessBoardIndex{
        static let indexToSquareRatio: CGFloat = 0.24
        static let labels = "12345678ABCDEFGH".characters
        static let color = UIColor.black
        static let fontSize: CGFloat = 10
        static let positions: [Character:Position] =
            [
                "A":Position(row: 7,col: 0)!,
                "B":Position(row: 7,col: 1)!,
                "C":Position(row: 7,col: 2)!,
                "D":Position(row: 7,col: 3)!,
                "E":Position(row: 7,col: 4)!,
                "F":Position(row: 7,col: 5)!,
                "G":Position(row: 7,col: 6)!,
                "H":Position(row: 7,col: 7)!,
                "1":Position(row: 7,col: 0)!,
                "2":Position(row: 6,col: 0)!,
                "3":Position(row: 5,col: 0)!,
                "4":Position(row: 4,col: 0)!,
                "5":Position(row: 3,col: 0)!,
                "6":Position(row: 2,col: 0)!,
                "7":Position(row: 1,col: 0)!,
                "8":Position(row: 0,col: 0)!
        ]
    }
    
    
    private func setUpChessBoardIndices(){
        for label in ChessBoardIndex.labels {
            if let position = ChessBoardIndex.positions[label]{
                let chessBoardSquare = chessBoardSquares[position.row][position.col]
                addChessBoardIndex(label: label, to: chessBoardSquare)
            }
        }
    }
    
    private func addChessBoardIndex(label: Character, to chessBoardSquare: ChessBoardSquareView){
        if ChessBoardIndex.labels.contains(label){
            let indexFrame = frameOf(indexLabel:label, within: chessBoardSquare.bounds)
            let indexLabel = UILabel()
            indexLabel.textColor = ChessBoardIndex.color
            indexLabel.text = String(label)
            indexLabel.font = indexLabel.font.withSize(ChessBoardIndex.fontSize)
            indexLabel.frame = indexFrame
            chessBoardSquare.addSubview(indexLabel)
        }
    }
    
    private func frameOf(indexLabel:Character, within bounds:CGRect)->CGRect{
        let frameSize = bounds.size * ChessBoardIndex.indexToSquareRatio
        if Int(String(indexLabel)) != nil {
            return CGRect(origin: CGPoint.zero, size: frameSize)
        }else{
            return CGRect(lowerRight: bounds.lowerRight, size: frameSize)
        }
    }
    
    //MARK: - Moving SubViews AKA moving Pieces
    
    //Moves a piece from oldPosition to newPosition
    //the optional pieceToPutBack parameter is placed at the oldPosition
    //this parameters is used when undoing a move in which a piece was captured
    //the animate parameter is used subclasses overriding this method
    //return tuple contains a Bool and an optional ChessPieceView
    //the first component (Bool) is true if a piece was infact moved,
    //i.e. if there was a piece at oldPosition
    //the second component (ChessPieceView?) is the piece previously located at newPosition
    //or nil if no piece was there
    func movePiece(from oldPosition: ChessBoardView.Position,
                   to newPosition: ChessBoardView.Position,
                   positionOfPieceCaptured: Position?=nil,
                   putPieceBack:(view:ChessPieceView,position: Position)?=nil,
                   animate:Bool=false)->(Bool, ChessPieceView?){
        //get the piece to move from old position
        //if no piece is present at this position return with failure
        guard let pieceToMove = removePiece(from: oldPosition) else {return (false,nil)}
        //place it at the new position and retrieve the piece replaced if any
        let pieceReplaced = set(piece: pieceToMove, at: newPosition)
        //check if moving the piece removed the captured piece form the boardView
        var pieceCaptured:ChessPieceView?
        if pieceReplaced == nil, positionOfPieceCaptured != nil{
            //if it did not, remove it (Deals with Prise En passant)
            pieceCaptured = removePiece(from: positionOfPieceCaptured!)
        }
        
        //put the piece Back if applicable
        if let pieceToPutBack = putPieceBack{
            _ = set(piece: pieceToPutBack.view, at: pieceToPutBack.position)
        }
        //debugging
        printMoveInfo(pieceWasMoved: true,
                      pieceToMove: pieceToMove,
                      from: oldPosition,
                      to: newPosition,
                      pieceEaten: pieceCaptured)
        //return with success
        return (true,pieceCaptured)
    }
    
    //Method used for debugging move Piece
    private func printMoveInfo(pieceWasMoved: Bool,
                               pieceToMove: ChessPieceView,
                               from oldPosition: ChessBoardView.Position,
                               to newPosition: ChessBoardView.Position,
                               pieceEaten: ChessPieceView?){
        if !pieceWasMoved {
            print("No Piece was moved!")
        }else{
            print("\(pieceToMove.description) was moved from \(oldPosition.description) to \(newPosition.description)")
            if let pieceEaten = pieceEaten{
                print("\(pieceEaten.description) was captured!")
            }
        }
    }
    
    //Places a piece at the desired position on the board
    //returns the piece that previously occupied that position or nil if no piece was there
    func set(piece: ChessPieceView?, at position: ChessBoardView.Position, animate:Bool=false)->ChessPieceView?{
        let replacedPiece = self[position.row,position.col].chessPiece
        self[position.row,position.col].chessPiece = piece
        return replacedPiece
    }
    
    //attempts to remove a piece from the specified location
    //returns the piece it removed or nil if no piece was located at that square
    func removePiece(from position: ChessBoardView.Position, animate:Bool=false)->ChessPieceView?{
        return set(piece: nil, at: position)
    }
    
    //MARK: - Initializers
    
    convenience override init(frame: CGRect){
        self.init(frame: frame,
                  colorOfWhiteSquares: Default.colorOfWhiteSquares,
                  colorOfBlackSquares: Default.colorOfBlackSquares,
                  colorOfSelectedBlackSquares: Default.colorOfSelectedBlackSquares,
                  drawIndices:true)
    }
    
    convenience init(frame: CGRect, colorOfWhiteSquares: UIColor,colorOfBlackSquares: UIColor){
        self.init(frame: frame,
                  colorOfWhiteSquares: colorOfWhiteSquares,
                  colorOfBlackSquares: colorOfBlackSquares,
                  colorOfSelectedBlackSquares: Default.colorOfSelectedBlackSquares,
                  drawIndices: true)
    }
    
    init(frame: CGRect,
         colorOfWhiteSquares: UIColor,
         colorOfBlackSquares: UIColor,
         colorOfSelectedBlackSquares: UIColor,
         drawIndices: Bool){
        
        self.colorOfWhiteSquares = colorOfWhiteSquares
        self.colorOfBlackSquares = colorOfBlackSquares
        self.colorOfSelectedBlackSquares = colorOfSelectedBlackSquares
        self.drawIndices = drawIndices
        self.isSetUp = false
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK - Subscript used to access chessBoardSquares array
    
    func indexIsValid(row: Int, column: Int) -> Bool {
        return  row >= 0 &&
                row < Dimensions.SquaresPerRow &&
                column >= 0 &&
                column < Dimensions.SquaresPerColumn
    }
    
    subscript(row: Int, col: Int) -> ChessBoardSquareView {
        get {
            assert(indexIsValid(row: row, column: col), "Index out of range")
            return chessBoardSquares[row][col]
        }
//        set {
//            //assert(indexIsValid(row: row, column: column), "Index out of range")
//            chessBoardSquares[row][col] = newValue
//        }
    }
    
    //MARK: - Struct Used to model the position of chessboard square
    //can be used as key to dictionary that stores data based on chesssquare positions
    
    struct Position: Hashable, Equatable{
        static let validRowRange = (0..<ChessBoardView.Dimensions.SquaresPerRow)
        static let validColRange = (0..<ChessBoardView.Dimensions.SquaresPerColumn)
        static let columnLetters = [0:"A",1:"B",2:"C",3:"D",4:"E",5:"F",6:"G",7:"H"]
        var (row,col): (Int, Int)
        
        
        var hashValue: Int {
            return row * 10 + col
        }
        
        //description style like A3 or E4
        var description: String{
            return "(\(Position.columnLetters[col]!),\(8-row))"
        }
        
        static func == (lhs: Position, rhs: Position) -> Bool {
            return lhs.row == rhs.row && lhs.col == rhs.col
        }
        
        private func isValidPosition()->Bool{
            return  Position.validRowRange.contains(self.row) &&
                Position.validColRange.contains(self.col)
        }
        
        init?(row: Int, col: Int){
            (self.row,self.col) = (row,col)
            if !isValidPosition(){ return nil}
        }
        
    }
}
