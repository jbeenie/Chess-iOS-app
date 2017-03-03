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
        static let DisAppearDuration: TimeInterval = 0.3
        static let DisAppearDelay: TimeInterval = 0
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
        chessPieceView.alpha = 0
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
        //Get the ChessPieceView that was moved and temporarily hide it
        let pieceMoved = self[newPosition.row,newPosition.col].chessPiece!
        pieceMoved.isHidden = true
        //Temporarily Hide the piece that was put back
        putPieceBack?.view.isHidden = true
        
        //Create a copy of the moved chess Pieces 
        //This copy will be used to animate it moving
        //Resize it and position it at the oldPosition
        let pieceMovedCopy = ChessPieceView(chessPieceView: pieceMoved)
        AddResized(chessPieceView: pieceMovedCopy, at: oldPosition)
        
        var animateReapperanceOfPiecePutBack:(()->Void)? = nil
        if let putPieceBack = putPieceBack{
            let pieceToPutBackCopy = ChessPieceView(chessPieceView: putPieceBack.view)
            animateReapperanceOfPiecePutBack = {
                self.animateAppearanceOf(chessPieceView: pieceToPutBackCopy,
                                         at: putPieceBack.position,
                                         completion: {finished in
                                            putPieceBack.view.isHidden = false}
                )
            }
        }
        
        //prepare moving closure
        let animateMovingOfPiece = {
            self.animateMovingOf(chessPieceView: pieceMovedCopy,
                                 from: oldPosition,
                                 to: newPosition,
                                 completion: {finished in pieceMoved.isHidden = false;
                                                animateReapperanceOfPiecePutBack?()
                                                }
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
                                   completion: {finished in animateMovingOfPiece()})
        }else{
            animateMovingOfPiece()
        }
        return (moveSuccessful,pieceCaptured)
    }
}
