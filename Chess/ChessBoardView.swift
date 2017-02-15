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
    
    //MARK: - Subviews
    //MARK: ChessBoard square array
    lazy private var chessBoardSquares: [[ChessBoardSquareView]] = self.setUpChessBoardSqaures()
    
    //help method used to setup the chessboard square array
    private func setUpChessBoardSqaures() -> [[ChessBoardSquareView]] {
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
                    chessBoardSquare.position = SquarePosition(row: row, col: col)
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
    func setUpChessBoard(){
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
        static let positions: [Character:SquarePosition] =
            [
                "A":SquarePosition(row: 7,col: 0)!,
                "B":SquarePosition(row: 7,col: 1)!,
                "C":SquarePosition(row: 7,col: 2)!,
                "D":SquarePosition(row: 7,col: 3)!,
                "E":SquarePosition(row: 7,col: 4)!,
                "F":SquarePosition(row: 7,col: 5)!,
                "G":SquarePosition(row: 7,col: 6)!,
                "H":SquarePosition(row: 7,col: 7)!,
                "1":SquarePosition(row: 7,col: 0)!,
                "2":SquarePosition(row: 6,col: 0)!,
                "3":SquarePosition(row: 5,col: 0)!,
                "4":SquarePosition(row: 4,col: 0)!,
                "5":SquarePosition(row: 3,col: 0)!,
                "6":SquarePosition(row: 2,col: 0)!,
                "7":SquarePosition(row: 1,col: 0)!,
                "8":SquarePosition(row: 0,col: 0)!
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
    //returns a tuple containing a Bool and an optional ChessPieceView
    //the first component (Bool) is true if a piece was infact moved,
    //i.e. if there was a piece at oldPosition
    //the second component (ChessPieceView?) is the piece previously located at newPosition
    //or nil if no piece was there
    func movePiece(from oldPostion: ChessBoardView.SquarePosition, to newPosition: ChessBoardView.SquarePosition)->(Bool, ChessPieceView?){
        if let pieceToMove = removePiece(from: oldPostion){
            let pieceEaten = set(piece: pieceToMove, at: newPosition)
            
            printMoveInfo(pieceWasMoved: true,
                          pieceToMove: pieceToMove,
                          from: oldPostion,
                          to: newPosition,
                          pieceEaten: pieceEaten)
            
            return (true, pieceEaten)
        }
        return (false,nil)
        
    }
    
    //Method used for debugging move Piece
    private func printMoveInfo(pieceWasMoved: Bool,
                               pieceToMove: ChessPieceView,
                               from oldPosition: ChessBoardView.SquarePosition,
                               to newPosition: ChessBoardView.SquarePosition,
                               pieceEaten: ChessPieceView?){
        if !pieceWasMoved {
            print("No Piece was moved!")
        }else{
            print("\(pieceToMove.description) was moved from \(oldPosition.description) to \(newPosition.description)")
            if let pieceEaten = pieceEaten{
                print("\(pieceEaten.description) was eaten!")
            }
        }
    }
    
    //Places a piece at the desired position on the board
    //returns the piece that previously occupied that position or nil if no piece was there
    func set(piece: ChessPieceView?, at position: ChessBoardView.SquarePosition)->ChessPieceView?{
        let replacedPiece = self[position.row,position.col].chessPiece
        self[position.row,position.col].chessPiece = piece
        return replacedPiece
    }
    
    //attempts to remove a piece from the specified location
    //returns the piece it removed or nil if no piece was located at that square
    func removePiece(from position: ChessBoardView.SquarePosition)->ChessPieceView?{
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
    
    struct SquarePosition: Hashable, Equatable{
        static let validRowRange = (0..<ChessBoardView.Dimensions.SquaresPerRow)
        static let validColRange = (0..<ChessBoardView.Dimensions.SquaresPerColumn)
        static let columnLetters = [0:"A",1:"B",2:"C",3:"D",4:"E",5:"F",6:"G",7:"H"]
        var (row,col): (Int, Int)
        
        
        var hashValue: Int {
            return row * 10 + col
        }
        
        //FIXME: Makes description style like A3, how do you have int to Char to get next letter?
        var description: String{
            let description:String = "(\(SquarePosition.columnLetters[col]!),\(8-row))"
            return description
        }
        
        static func == (lhs: SquarePosition, rhs: SquarePosition) -> Bool {
            return lhs.row == rhs.row && lhs.col == rhs.col
        }
        
        private func isValidPosition()->Bool{
            return  SquarePosition.validRowRange.contains(self.row) &&
                SquarePosition.validColRange.contains(self.col)
        }
        
        init?(row: Int, col: Int){
            (self.row,self.col) = (row,col)
            if !isValidPosition(){ return nil}
        }
        
    }
}
