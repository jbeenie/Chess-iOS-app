//
//  ChessBoardSquare.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-10.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

@IBDesignable
class ChessBoardSquare: BoardSquare {
    struct Ratios{
        static let ChessPieceToSquare: CGFloat = 0.7
    }
    
    private let ChessPieceToSquareRatio = Ratios.ChessPieceToSquare
    
    var chessPiece: ChessPiece? = nil{
        //remove the chessPiece subview from the chessboard square if it is set to nil
        willSet(newChessPiece){
            //remove the previous chess piece from chessboard squares view if its not nil
            chessPiece?.removeFromSuperview()
            //if the new chess piece is not nil add as a subview of chess board square
            if let newChessPiece =  newChessPiece{
                //center chess piece within board square
                let chessPieceframe = CGRect(center: bounds.mid, size: bounds.size * ChessPieceToSquareRatio)
                newChessPiece.frame = chessPieceframe
                self.addSubview(newChessPiece)
            }
        }
    }
}

extension CGRect {
    var mid: CGPoint { return CGPoint(x: midX, y: midY) }
    
    
    init(center: CGPoint, size: CGSize) {
        let upperLeft = CGPoint(x: center.x-size.width/2, y: center.y-size.height/2)
        self.init(origin: upperLeft, size: size)
    }
}

extension CGSize {
    static func * (size: CGSize, scale: CGFloat) -> CGSize {
        return CGSize(width: size.width * scale , height: size.height * scale)
    }
    
    
}
