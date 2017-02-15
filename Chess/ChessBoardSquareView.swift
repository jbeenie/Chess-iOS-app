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
                //center chess piece within board square
                //and maintain its aspect ratio
                let chessPieceHeight = bounds.size.height * Ratios.ChessPieceToSquare
                let chessPieceWidth = newChessPiece.aspectRatio * chessPieceHeight
                let chessPieceSize = CGSize(width: chessPieceWidth, height: chessPieceHeight)
                let chessPieceframe = CGRect(center: bounds.mid, size: chessPieceSize)
                newChessPiece.frame = chessPieceframe
                self.addSubview(newChessPiece)
            }
        }
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
