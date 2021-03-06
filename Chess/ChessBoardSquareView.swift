//
//  ChessBoardSquare.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-10.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit


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
                self.superview?.addSubview(newChessPiece)
                //resize chess pieceView and its animation copy
                resize(chessPieceView: newChessPiece)
                //position chess pieceView
                newChessPiece.center = frame.mid
            }
        }
    }
    
    //MAKR: - View Life Cycle Methods
    
    override func layoutSubviews() {
        updateChessPieceFrame()
    }
    
    //MARK: - Methods
    
    func updateChessPieceFrame(){
        if let chessPiece = chessPiece{
            //resize chess pieceView and its animation copy
            resize(chessPieceView: chessPiece)
            //position chess pieceView
            chessPiece.center = frame.mid
            chessPiece.aninmationCopy.center = chessPiece.center
        }
    }
    
    func resize(chessPieceView:ChessPieceView){
        //resize the chessPieceView so it fits within the chessBoardSquare
        //and maintain its aspect ratio
        let newChessPieceHeight = bounds.size.height * Ratios.ChessPieceToSquare
        let newChessPieceWidth = chessPieceView.aspectRatio * newChessPieceHeight
        let newChessPieceSize = CGSize(width: newChessPieceWidth, height: newChessPieceHeight)
        chessPieceView.frame =  CGRect(center: chessPieceView.center, size: newChessPieceSize)
        chessPieceView.aninmationCopy.frame = chessPieceView.frame
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
