//
//  ChessBoardSquare.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-10.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

@IBDesignable
class ChessBoardSquareView: BoardSquareView {
    
    struct Ratios{
        static let ChessPieceToSquare: CGFloat = 0.575
    }
    
    var isOccupied: Bool {
        return chessPiece != nil
    }
    
    var position: ChessBoardView.Position! = nil
    
    var chessPiece: ChessPieceView? = nil{
        //remove the chessPiece subview from the chessboard square if it is set to nil
        willSet(newChessPiece){
            //remove the previous chess piece from chessboard squares view if its not nil
            chessPiece?.removeFromSuperview()
            //if the new chess piece is not nil add as a subview of chess board square
            if let newChessPiece =  newChessPiece{
                self.addSubview(newChessPiece)
                //resize chess pieceView
                resize(chessPieceView: newChessPiece)
                //position chess pieceView
                newChessPiece.center = bounds.mid
            }
        }
    }
    
    //MARK: - Methods
    
    func resize(chessPieceView:ChessPieceView){
        //resize the chessPieceView so it fits within the chessBoardSquare
        //and maintain its aspect ratio
        let newChessPieceHeight = bounds.size.height * Ratios.ChessPieceToSquare
        let newChessPieceWidth = chessPieceView.aspectRatio * newChessPieceHeight
        let newChessPieceSize = CGSize(width: newChessPieceWidth, height: newChessPieceHeight)
        chessPieceView.frame =  CGRect(center: chessPieceView.center, size: newChessPieceSize)
    }
}

extension ChessBoardSquareView {
    static func ==(lhs: ChessBoardSquareView, rhs: ChessBoardSquareView) -> Bool {
        if let positionOfLeft = lhs.position, let positionOfRight =  rhs.position{
            return positionOfLeft == positionOfRight
        }
        return false
    }
}
