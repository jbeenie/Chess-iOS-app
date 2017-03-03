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
        static let MoveDuration: TimeInterval = 1
        static let MoveDelay: TimeInterval = 0
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
    
    private func resize(chessPieceView:ChessPieceView, at position:Position){
        //first resize the chessPieceView
        self[position.row,position.col].resize(chessPieceView: chessPieceView)
        //then position it
        chessPieceView.center = self.centerOfSquare(at:position)
    }

    private func animateMovingOf(chessPieceView:ChessPieceView, from oldPosition: Position, to newPosition:Position, completion: ((Bool) -> Void)? = nil){
        //resize and position chesspiece
        resize(chessPieceView: chessPieceView, at: oldPosition)
        //make sure piece is not hidden
        chessPieceView.isHidden = false
        UIView.animate(
            withDuration: Animation.MoveDuration,
            delay: Animation.MoveDelay,
            options: Animation.MoveOptions,
            animations: {chessPieceView.center = self.centerOfSquare(at: newPosition)},
            completion: {finished in
                if (finished){
                    chessPieceView.isHidden=true;completion?(finished)
                }
            }
        )
    }

    
    private func animateDisAppearanceOf(chessPieceView:ChessPieceView, at position:Position, completion: ((Bool) -> Void)? = nil){
        //resize and position chesspiece
        resize(chessPieceView: chessPieceView, at: position)
        //make sure piece is not hidden to begin with
        chessPieceView.isHidden = false
        UIView.animateAlphaTransition(
            of: chessPieceView,
            toAlpha: 0,
            withDuration: Animation.DisAppearDuration,
            delay: Animation.DisAppearDelay,
            options: Animation.DisAppearOptions,
            completion: {finished in
                if(finished){
                    chessPieceView.isHidden=true;completion?(finished)
                }
            }
        )
    }
    
    private func animateAppearanceOf(chessPieceView:ChessPieceView, at position:Position, completion: ((Bool) -> Void)? = nil){
        //resize and position chesspiece
        resize(chessPieceView: chessPieceView, at: position)
        //make sure piece is not hidden and alpha is 0
        chessPieceView.alpha = 0
        chessPieceView.isHidden = false
        UIView.animateAlphaTransition(
            of: chessPieceView,
            toAlpha: 1,
            withDuration: Animation.AppearDuration,
            delay: Animation.AppearDelay,
            options: Animation.AppearOptions,
            completion: {finished in
                if(finished) {
                    chessPieceView.isHidden=true;completion?(finished)
                }
            }
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
        
        //Reveal the animation copy at the starting position
        //resize and position chesspiece
        resize(chessPieceView: pieceMoved.aninmationCopy, at: oldPosition)
        pieceMoved.aninmationCopy.isHidden = false
        
        var animateReapperanceOfPiecePutBack:(()->Void)? = nil
        if let putPieceBack = putPieceBack{
            animateReapperanceOfPiecePutBack = {
                self.animateAppearanceOf(
                    chessPieceView: putPieceBack.view.aninmationCopy,
                    at: putPieceBack.position,
                    completion: {finished in
                            putPieceBack.view.isHidden = false
                    }
                )
            }
        }
        
        //prepare moving closure
        let animateMovingOfPiece = {
            self.animateMovingOf(
                chessPieceView: pieceMoved.aninmationCopy,
                from: oldPosition,
                to: newPosition,
                completion: {finished in
                        pieceMoved.isHidden = false;
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
            animateDisAppearanceOf(
                chessPieceView: pieceCaptured!.aninmationCopy,
                at: positionOfPieceCaptured,
                completion: {finished in if(finished) {animateMovingOfPiece()}})
        }else{
            animateMovingOfPiece()
        }
        return (moveSuccessful,pieceCaptured)
    }
}
