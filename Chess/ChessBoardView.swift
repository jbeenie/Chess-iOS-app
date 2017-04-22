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
    func centerOfSquare(at position: ChessBoardView.Position?)->CGPoint?{
        return self[position?.row,position?.col]?.center ?? nil
    }
    
    //MARK: - Subviews
    //MARK: ChessBoard square array
    lazy private var chessBoardSquares: [[ChessBoardSquareView]] = self.setUpChessBoardSquares()
    
    internal var pieces:[ChessPieceView]{
        var chessPieceviews = [ChessPieceView]()
        for subview in self.subviews {
            if let chessPieceView = subview as? ChessPieceView{
                chessPieceviews.append(chessPieceView)
            }
        }
        return chessPieceviews
    }
    
    //MARK: Helper method used to setup the chessboard square array
    private func setUpChessBoardSquares() -> [[ChessBoardSquareView]] {
        var chessBoardSquares = [[ChessBoardSquareView]]()
        var isBlack = false
        
        for row in 0..<Dimensions.SquaresPerRow {
            chessBoardSquares.append(Array<ChessBoardSquareView>())
            for col in 0..<Dimensions.SquaresPerColumn {
                //set up chess board square initialization parameters
                let color = isBlack ? colorOfBlackSquares : colorOfWhiteSquares
                let selectedColor = isBlack ? colorOfSelectedBlackSquares : colorOfSelectedWhiteSquares
            
                //initialize chessboard square
                if let chessBoardSquare = ChessBoardSquareView(frame: CGRect.zero, color: color, selectedColor: selectedColor){
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
    
    //MARK: - method used to update the frame of the chessboardSquares upon bounds change
    func updateChessBoardSquaresFrames(){
        //precompute square side length and size once
        //to avoid potential computing different values in for loop
        let sideLength: CGFloat = min(bounds.height, bounds.width)/8
        let size = CGSize(width: sideLength, height: sideLength)
        
        for row in 0..<Dimensions.SquaresPerRow {
            for col in 0..<Dimensions.SquaresPerColumn {
                //set up chess board square initialization parameters
                let origin = CGPoint(x: sideLength*CGFloat(col), y: sideLength*CGFloat(row))
                let frame = CGRect(origin: origin, size: size)
                //set frame of chessboard square
                chessBoardSquares[row][col].frame = frame
            }
        }
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
    
    //MARK: Setting up board indices
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
    
    //MARK: - Performing and undoing Complex Moves
    
    //MARK: Struct that encapsulates the information used by the ChessBoardView 
    //to move a chessPiece view. When External classes tell a ChessBoardView to 
    //move its pieces on a they must do so using instances of this move struct 
    //i.e. by calling the perform(move:) and undo(move:) methods
    struct Move{
        let startPosition: ChessBoardView.Position
        let endPosition: ChessBoardView.Position
        let pieceCaptured: ChessPieceView?
        let positionOfPieceToCapture:ChessBoardView.Position?
        let pieceToPromoteTo: ChessPieceView?
        let pieceToDemoteTo: ChessPieceView?
        let rookStartPosition: ChessBoardView.Position?
        let rookEndPosition: ChessBoardView.Position?
        
        var description:String{
            var description = ""
            description += "Piece moved from \(startPosition.description) to \(endPosition.description)\nl"
            if let positionOfPieceToCapture = positionOfPieceToCapture{
                description += "Piece Captured at \(positionOfPieceToCapture)\n"
            }
            if let rookStartPosition = rookStartPosition, let rookEndPosition = rookEndPosition{
                description += "Move was Castle. Rook moved from \(rookStartPosition) to \(rookEndPosition)\n"
            }
            return description
        }
    }
    
    
    
    //MARK: - Moving Removing and setting SubViews AKA Pieces
    
    func movePiece(from startPosition:Position?, endPosition:Position?){
        guard let startPosition = startPosition, let endPosition = endPosition else {return}
        //remove the piece from the old position
        guard let pieceToMove = removePiece(from: startPosition) else {return}
        //place it at the new position
        _ = set(piece: pieceToMove, at: endPosition)
    }
    
    //Places a piece at the desired position on the board
    //returns the piece that previously occupied that position or nil if no piece was there
    func set(piece: ChessPieceView?, at position: ChessBoardView.Position?)->ChessPieceView?{
        guard let position = position else {return nil}
        let replacedPiece = self[position.row,position.col]!.chessPiece
        self[position.row,position.col]!.chessPiece = piece
        return replacedPiece
    }
    
    //attempts to remove a piece from the specified location
    //returns the piece it removed or nil if no piece was located at that square
    func removePiece(from position: ChessBoardView.Position?)->ChessPieceView?{
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
        self.colorOfWhiteSquares = Default.colorOfWhiteSquares
        self.colorOfBlackSquares = Default.colorOfBlackSquares
        self.colorOfSelectedBlackSquares = Default.colorOfSelectedBlackSquares
        self.drawIndices = true
        self.isSetUp = false
        super.init(coder: aDecoder)
    }
    
    //MARK - Subscript used to access chessBoardSquares array
    
    func indexIsValid(row: Int, column: Int) -> Bool {
        return  row >= 0 &&
                row < Dimensions.SquaresPerRow &&
                column >= 0 &&
                column < Dimensions.SquaresPerColumn
    }
    
    subscript(row: Int?, col: Int?) -> ChessBoardSquareView? {
        get {
            guard let row = row, let col = col else {return nil}
            guard indexIsValid(row: row, column: col) else {return nil}
            return chessBoardSquares[row][col]
        }
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
