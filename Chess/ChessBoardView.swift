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
                
                let squareColor = isBlack ? colorOfBlackSquares : colorOfWhiteSquares
                let squareSideLength:CGFloat = min(bounds.height, bounds.width)/8
                let squareSize = CGSize(width: squareSideLength, height: squareSideLength)
                let squareOrigin = CGPoint(x: squareSideLength*CGFloat(col), y: squareSideLength*CGFloat(row))
                let squareFrame = CGRect(origin: squareOrigin, size: squareSize)
                
                chessBoardSquares[row].append(ChessBoardSquareView(frame: squareFrame, color: squareColor))
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
    }
    
    //MARK: - Initializers
    
    convenience override init(frame: CGRect){
        self.init(frame: frame, colorOfWhiteSquares: Default.colorOfWhiteSquares, colorOfBlackSquares: Default.colorOfBlackSquares)
    }
    
    init(frame: CGRect, colorOfWhiteSquares: UIColor, colorOfBlackSquares: UIColor){
        self.colorOfWhiteSquares = colorOfWhiteSquares
        self.colorOfBlackSquares = colorOfBlackSquares
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK - Subscripts
    
    func indexIsValid(row: Int, column: Int) -> Bool {
        return  row >= 0 &&
                row < Dimensions.SquaresPerRow &&
                column >= 0 &&
                column < Dimensions.SquaresPerColumn
    }
    
    subscript(row: Int, col: Int) -> ChessBoardSquareView {
        get {
            //assert(indexIsValid(row: row, column: column), "Index out of range")
            return chessBoardSquares[row][col]
        }
        set {
            //assert(indexIsValid(row: row, column: column), "Index out of range")
            chessBoardSquares[row][col] = newValue
        }
    }
    
    //TODO: Override subcripts to be able to index chess set using index like A3

}
