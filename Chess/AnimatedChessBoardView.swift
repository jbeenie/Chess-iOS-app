//
//  AnimatedChessBoardView.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-01.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class AnimatedChessBoardView: ChessBoardView {
    //MARK: - Animation Constants
    struct Animation{
        static let MoveDuration: TimeInterval = 0.4
        static let MoveDelay: TimeInterval = 0.2
        static let MoveOptions: UIViewAnimationOptions = [UIViewAnimationOptions.curveEaseInOut]
        static let DisAppearDuration: TimeInterval = 0.4
        static let DisAppearDelay: TimeInterval = 0.2
        static let DisAppearOptions: UIViewAnimationOptions = [UIViewAnimationOptions.curveLinear]
        static let AppearDuration: TimeInterval = Animation.DisAppearDuration
        static let AppearDelay: TimeInterval = Animation.DisAppearDelay
        static let AppearOptions: UIViewAnimationOptions = [UIViewAnimationOptions.curveLinear]
    }
    
    //MARK: - Methods
    
    //MARK: - Helper Methods
    
    private func AddResized(chessPieceView:ChessPieceView, at position:Position){
        //first resize the chessPieceView
        self[position.row,position.col].resize(chessPieceView: chessPieceView)
        //then position it
        chessPieceView.center = self.centerOfSquare(at:position)
        self.addSubview(chessPieceView)
    }

    private func animateMovingOf(chessPieceView:ChessPieceView, from oldPosition: Position, to newPosition:Position, completion: ((Bool) -> Void)? = nil){
        AddResized(chessPieceView: chessPieceView, at: oldPosition)
        UIView.animate(withDuration: Animation.MoveDuration,
                       delay: Animation.MoveDelay,
                       options: Animation.MoveOptions,
                       animations: {chessPieceView.center = self.centerOfSquare(at: newPosition)},
                       completion: {finished in chessPieceView.removeFromSuperview();completion?(finished)})
    }

    
    private func animateDisAppearanceOf(chessPieceView:ChessPieceView, at position:Position, completion: ((Bool) -> Void)? = nil){
        AddResized(chessPieceView: chessPieceView, at: position)
        UIView.animateAlphaTransition(
            of: chessPieceView,
            toAlpha: 0,
            withDuration: Animation.DisAppearDuration,
            delay: Animation.DisAppearDelay,
            options: Animation.DisAppearOptions,
            completion: {finished in chessPieceView.removeFromSuperview();completion?(finished)}
        )
    }
    
    private func animateAppearanceOf(chessPieceView:ChessPieceView, at position:Position, completion: ((Bool) -> Void)? = nil){
        AddResized(chessPieceView: chessPieceView, at: position)
        UIView.animateAlphaTransition(
            of: chessPieceView,
            toAlpha: 1,
            withDuration: Animation.AppearDuration,
            delay: Animation.AppearDelay,
            options: Animation.AppearOptions,
            completion: {finished in chessPieceView.removeFromSuperview();completion?(finished)}
        )
    }
    
    
    //MARK: Exposed Methods
    
    override func removePiece(from position: ChessBoardView.Position, animate: Bool=false) -> ChessPieceView? {
        return self.set(piece: nil, at: position, animate: animate)
    }
    
    override func set(piece: ChessPieceView?, at position: ChessBoardView.Position, animate:Bool=false) -> ChessPieceView? {
        //place the piece on the board
        let pieceReplaced = super.set(piece: piece, at: position)
        //only animate the appearnace of a piece if animate = true
        guard animate else {return pieceReplaced}
        //only animate the cases where a piece is removed
        //or a piece is placed but no piece is removed
        if let pieceReplaced = pieceReplaced, piece == nil{
            //Create a copy of the replaced chess Piece
            //This copy will be used to animate its disappearance
            let pieceReplacedCopy = ChessPieceView(chessPieceView: pieceReplaced)
            animateDisAppearanceOf(chessPieceView: pieceReplacedCopy,
                                   at: position,
                                   completion: nil)
        }else if let piece = piece, pieceReplaced == nil{
            //first hide the piece
            piece.isHidden = true
            //Create a copy of the placed chess Piece with an alpha of 0
            //This copy will be used to animate its appearance
            let pieceCopy = ChessPieceView(chessPieceView: piece)
            pieceCopy.alpha = 0
            animateAppearanceOf(chessPieceView: pieceCopy,
                                   at: position,
                                   completion: {finished in piece.isHidden = false})
        }
        return pieceReplaced
    }
    
    override func movePiece(from oldPosition: Position,
                            to newPosition: Position,
                            positionOfPieceCaptured:Position?=nil,
                            putPieceBack:(view:ChessPieceView,position: Position)?=nil,
                            animate: Bool=true) -> (Bool, ChessPieceView?) {
        //move the piece on the board
        let (moveSuccessful,pieceCaptured) = super.movePiece(
            from: oldPosition,
            to: newPosition,
            positionOfPieceCaptured: positionOfPieceCaptured,
            putPieceBack: putPieceBack)
        
        //Ensure move is successful before proceeding
        guard moveSuccessful else {return (false,nil)}
        //if animate is false your done
        guard animate else {return (moveSuccessful,pieceCaptured)}
        //Get the ChessPieceView that was moved and hide it
        let pieceMoved = self[newPosition.row,newPosition.col].chessPiece!
        pieceMoved.isHidden = true
        
        //Create a copy of the moved chess Pieces 
        //This copy will be used to animate it moving
        //Resize it and position it at the oldPosition
        let pieceMovedCopy = ChessPieceView(chessPieceView: pieceMoved)
        AddResized(chessPieceView: pieceMovedCopy, at: oldPosition)
        
        //prepare moving closure
        let animateMovingOfPiece = { (finished:Bool) in
            self.animateMovingOf(chessPieceView: pieceMovedCopy,
                                 from: oldPosition,
                                 to: newPosition,
                                 completion:  {finished in pieceMoved.isHidden = false}
            )
        }
        
        //if there was a piece captured during the move
        if pieceCaptured != nil{
            //make sure position of piece captured is not nil
            guard let positionOfPieceCaptured = positionOfPieceCaptured else {
                print("Error: piece Captured not nil but positionOfPieceCaptured is nil!")
                return (false,nil)
            }
            //make a copy of the piece captured for animation
            let pieceCapturedCopy = ChessPieceView(chessPieceView: pieceCaptured!)
            animateDisAppearanceOf(chessPieceView: pieceCapturedCopy,
                                   at: positionOfPieceCaptured,
                                   completion: animateMovingOfPiece)
        }else{
            animateMovingOfPiece(true)
        }
        return (moveSuccessful,pieceCaptured)
    }
}
