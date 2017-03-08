//
//  AnimatedChessBoardView.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-01.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit
@IBDesignable
class AnimatedChessBoardView: ChessBoardView {
    //MARK: - Animation Constants
    struct Animation{
        static let MoveDuration: TimeInterval = 0.5
        static let MoveDelay: TimeInterval = 0.1
        static let MoveOptions: UIViewAnimationOptions = [UIViewAnimationOptions.curveEaseInOut,UIViewAnimationOptions.beginFromCurrentState]
        
        static let DisAppearDuration: TimeInterval = 0.5
        static let DisAppearDelay: TimeInterval = 0
        static let DisAppearOptions: UIViewAnimationOptions = [UIViewAnimationOptions.curveLinear]
        static let AlphaPreDisAppear: CGFloat = 1
        static let AlphaPostDisAppear: CGFloat = 0
        
        static let AppearDuration: TimeInterval = Animation.DisAppearDuration
        static let AppearDelay: TimeInterval = Animation.DisAppearDelay
        static let AppearOptions: UIViewAnimationOptions = [UIViewAnimationOptions.curveLinear]
        static let AlphaPreAppear: CGFloat = 0
        static let AlphaPostAppear: CGFloat = 1
    }
    
    var dissappearanceInProgress: Bool = false
    
    //MARK: - Methods
    
    //MARK: - Helper Methods

    private func animateMovingOf(chessPieceView:ChessPieceView, from oldPosition: Position, to newPosition:Position, completion: ((Bool) -> Void)? = nil){
        
        UIView.animate(
            withDuration: Animation.MoveDuration,
            delay: Animation.MoveDelay,
            options: Animation.MoveOptions,
            animations: {chessPieceView.center = self.centerOfSquare(at: newPosition)},
            completion: { finished in
                if (chessPieceView.center == self.centerOfSquare(at: newPosition)){
                    print("Finished Moving Piece")
                    completion?(true)
                }
            }
        )
    }

    
    private func animateDisAppearanceOf(chessPieceView:ChessPieceView, completion: ((Bool) -> Void)? = nil){
        dissappearanceInProgress = true
        chessPieceView.alpha = Animation.AlphaPreDisAppear
        UIView.animateAlphaTransition(
            of: chessPieceView,
            toAlpha: Animation.AlphaPostDisAppear,
            withDuration: Animation.DisAppearDuration,
            delay: Animation.DisAppearDelay,
            options: Animation.DisAppearOptions,
            completion: {finished in
                if(self.dissappearanceInProgress){
                    //indicate disappearance finished
                    self.dissappearanceInProgress = false
                    //remove animation copy from superview
                    //a new copy is created when it appears
                    chessPieceView.removeFromSuperview();
                    completion?(true)
                }
            }
        )
    }
    
    private func animateAppearanceOf(chessPieceView:ChessPieceView, completion: ((Bool) -> Void)? = nil){
        //interup dissapearance animation
        dissappearanceInProgress = false
        //make sure piece is not hidden and alpha is 0
        chessPieceView.alpha = Animation.AlphaPreAppear
        UIView.animateAlphaTransition(
            of: chessPieceView,
            toAlpha: Animation.AlphaPostAppear,
            withDuration: Animation.AppearDuration,
            delay: Animation.AppearDelay,
            options: Animation.AppearOptions,
            completion: {finished in
                    completion?(true)
            }
        )
    }
    
    private func animateTranstion(from disappearingChessPieceView:ChessPieceView, to appearingChessPieceView:ChessPieceView, completion: ((Bool)->Void)?){
        animateDisAppearanceOf(chessPieceView: disappearingChessPieceView)
        animateAppearanceOf(chessPieceView: appearingChessPieceView, completion: completion)
    }
    
    
    //MARK: Exposed Methods
    
    func resize(chessPieceView:ChessPieceView, at position:Position){
        //first resize the chessPieceView
        self[position.row,position.col].resize(chessPieceView: chessPieceView)
        //then position it
        chessPieceView.center = self.centerOfSquare(at:position)
    }
    
    func movePiece(from oldPosition: Position,
                            to newPosition: Position,
                            positionOfPieceCaptured:Position?=nil,
                            putPieceBack:(view:ChessPieceView,position: Position)?=nil,
                            pieceToPromoteTo:ChessPieceView?,
                            animate: Bool=true) -> (Bool, ChessPieceView?) {
        
        //Handle the case where promotion occurs in a seperate method
        //to minimize the complexity of this animation movePiece method
        if let pieceToPromoteTo = pieceToPromoteTo {
            return movePiece(from: oldPosition,
                             to: newPosition,
                             positionOfPieceCaptured: positionOfPieceCaptured,
                             putPieceBack: putPieceBack,
                             andPromoteTo: pieceToPromoteTo,
                             animate: animate)
        }
        
        
        //move the piece on the board
        let (moveSuccessful,pieceCaptured) = super.movePiece(
            from: oldPosition,
            to: newPosition,
            positionOfPieceCaptured: positionOfPieceCaptured,
            putPieceBack: putPieceBack,
            pieceToPromoteTo: pieceToPromoteTo)
        
        //Ensure move is successful before proceeding
        guard moveSuccessful else {return (false,nil)}
        //if animate is false your done
        guard animate else {return (moveSuccessful,pieceCaptured)}
        //Get the ChessPieceView that was moved and temporarily hide it
        let pieceMoved = self[newPosition.row,newPosition.col].chessPiece!
        pieceMoved.isHidden = true
        //Temporarily Hide the piece that was put back
        putPieceBack?.view.isHidden = true
        
        
        pieceMoved.aninmationCopy.isHidden = false
        
        var animateReapperanceOfPiecePutBack:(()->Void)? = nil
        if let putPieceBack = putPieceBack{
            animateReapperanceOfPiecePutBack = {
                self.animateAppearanceOf(
                    chessPieceView: putPieceBack.view.aninmationCopy,
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
                        print("finished moving closure")
                        animateReapperanceOfPiecePutBack?()
                }
            )
        }

        
        //if there was a piece captured during the move
        if pieceCaptured != nil{
            //make sure position of piece captured is not nil
            guard let _ = positionOfPieceCaptured else {
                print("Error: piece Captured not nil but positionOfPieceCaptured is nil!")
                return (false,nil)
            }
            animateDisAppearanceOf(
                chessPieceView: pieceCaptured!.aninmationCopy,
                completion: {finished in animateMovingOfPiece()}
            )
        }else{
            animateMovingOfPiece()
        }
        return (moveSuccessful,pieceCaptured)
    }
    
    
    //Handle Animation sequences that involve promitions seperately
    private func movePiece(from oldPosition: Position,
                   to newPosition: Position,
                   positionOfPieceCaptured:Position?=nil,
                   putPieceBack:(view:ChessPieceView,position: Position)?=nil,
                   andPromoteTo pieceToPromoteTo:ChessPieceView,
                   animate: Bool=true) -> (Bool, ChessPieceView?){
        
        //record the piece to move before you move it
        //because it gets replaced by another chessPieceView when promotions occur
        let pieceToMove = self[oldPosition.row,oldPosition.col].chessPiece!

        //move the piece on the board
        let (moveSuccessful,pieceCaptured) = super.movePiece(
            from: oldPosition,
            to: newPosition,
            positionOfPieceCaptured: positionOfPieceCaptured,
            putPieceBack: putPieceBack,
            pieceToPromoteTo: pieceToPromoteTo)
        
        //Ensure move is successful before proceeding
        guard moveSuccessful else {return (false,nil)}
        //if animate is false your done
        guard animate else {return (moveSuccessful,pieceCaptured)}
        
        //temporarily hide the promoted to piece
        let pieceChangedTo = self[newPosition.row,newPosition.col].chessPiece!
        pieceChangedTo.isHidden = true
        
        //determine whether or not you are undoing a move or not
        let undoingAMove = (pieceToMove.chessPieceIdentifier.type != .Pawn)
        
        //Temporarily Hide the piece that was put back
        putPieceBack?.view.isHidden = true
        
        //Note there is no need to hide the piece to move itself
        //because it was remove during the promotion (in the call to super.movePiece)
        pieceToMove.aninmationCopy.isHidden = false
        
        //Closure for putting piece back
        var animateReapperanceOfPiecePutBack:(()->Void)? = nil
        if let putPieceBack = putPieceBack{
            animateReapperanceOfPiecePutBack = {
                self.animateAppearanceOf(
                    chessPieceView: putPieceBack.view.aninmationCopy,
                    completion: {finished in
                        putPieceBack.view.isHidden = false
                    }
                )
            }
        }
        
        //Closure for moving piece
        let animateMovingOfPiece = { (completion:((Bool)->Void)?) in
            self.animateMovingOf(
                chessPieceView: pieceToMove.aninmationCopy,
                from: oldPosition,
                to: newPosition,
                completion: completion
            )
        }
        
        //Closure for promotion/demotion
        let animateChangingOfPiece = { (completion:((Bool)->Void)?) in
            self.animateTranstion(
                from: pieceToMove,
                to: pieceChangedTo,
                completion: completion
            )
        }
        
        if !undoingAMove{
            //if there was a piece captured during the move
            if let pieceCaptured = pieceCaptured{
                animateDisAppearanceOf(chessPieceView: pieceCaptured.aninmationCopy) { finished in
                    animateMovingOfPiece{ finished in animateChangingOfPiece(nil)}
                }
                //otherwise if there was no piece captured during the move
            }else {
                animateMovingOfPiece{ finished in animateChangingOfPiece(nil)}
            }
        }else{
            animateChangingOfPiece{ finished in
                animateMovingOfPiece{ finished in
                    animateReapperanceOfPiecePutBack?()
                }
            }

        }
                return (moveSuccessful,pieceCaptured)
    }
}
