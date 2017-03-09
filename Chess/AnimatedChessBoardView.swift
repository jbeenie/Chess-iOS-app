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

    private func animateMovingOf(chessPieceView:ChessPieceView?, to newPosition:Position?, completion: ((Bool) -> Void)? = nil){
        
        UIView.animate(
            withDuration: Animation.MoveDuration,
            delay: Animation.MoveDelay,
            options: Animation.MoveOptions,
            animations: {
                if let newCenter = self.centerOfSquare(at: newPosition){
                    chessPieceView?.center = newCenter
                }
            },
            completion: { finished in
                if let chessPieceView = chessPieceView, let newPosition = newPosition{
                    if (chessPieceView.center == self.centerOfSquare(at: newPosition)){
                        print("Finished Moving Piece")
                        completion?(true)
                    }
                }
            }
        )
    }

    private func animateDisAppearanceOf(chessPieceView:ChessPieceView?, completion: ((Bool) -> Void)? = nil){
        dissappearanceInProgress = true
        chessPieceView?.alpha = Animation.AlphaPreDisAppear
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
                    chessPieceView?.removeFromSuperview();
                    completion?(true)
                }
            }
        )
    }
    
    private func animateAppearanceOf(chessPieceView:ChessPieceView?, completion: ((Bool) -> Void)? = nil){
        //interup dissapearance animation
        dissappearanceInProgress = false
        //make sure piece is not hidden and alpha is 0
        chessPieceView?.alpha = Animation.AlphaPreAppear
        //add the animation copy as a subview of the boardview
        //if let chessPieceView = chessPieceView{self.addSubview(chessPieceView)}
        chessPieceView?.isHidden = false
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
    
    private func animateTranstion(from disappearingChessPieceView:ChessPieceView?, to appearingChessPieceView:ChessPieceView?, completion: ((Bool)->Void)? = nil){
        //verify both arguments are not nil before executing animation
        guard let appearingChessPieceView = appearingChessPieceView, let disappearingChessPieceView = disappearingChessPieceView else {
            completion?(true);return
        }
        animateDisAppearanceOf(chessPieceView: disappearingChessPieceView)
        animateAppearanceOf(chessPieceView: appearingChessPieceView, completion: completion)
    }
    
    
    //MARK: Exposed Methods
    
    func resize(chessPieceView:ChessPieceView, at position:Position){
        //first resize the chessPieceView
        self[position.row,position.col]!.resize(chessPieceView: chessPieceView)
        //then position it
        chessPieceView.center = self.centerOfSquare(at:position)!
    }
    
    func perform(move: Move, animate: Bool){
        //Get the piece to move in case its a pawn that is promoted 
        //Get the piece captured as well
        //(do this before calling super.perform)
        let pieceToMove = self[move.startPosition.row,move.startPosition.col]!.chessPiece!
        print(pieceToMove.aninmationCopy)
        print(pieceToMove.aninmationCopy.isHidden)
        print(pieceToMove.aninmationCopy.superview)
        
        let pieceCaptured = self[move.positionOfPieceToCapture?.row,move.positionOfPieceToCapture?.col]?.chessPiece
        
        //perfrom the move
        super.perform(move: move)
        
        //if animate is false your done
        guard animate else {return}
        
        //Get a handle on the pieces moved
        let rookMoved = self[move.rookEndPosition?.row,move.rookEndPosition?.col]?.chessPiece
        
        //temporarily hide the
        //1. piece to move
        //2. piece to promote to (if any)
        //3. extra rook to move (if any)
        pieceToMove.isHidden = true
        move.pieceToPromoteTo?.isHidden = true
        rookMoved?.isHidden = true
        
        //unhide the appropriate animation copies
        pieceToMove.aninmationCopy.isHidden = false
        rookMoved?.aninmationCopy.isHidden = false
        
        
    
        //Capturing Closure
        let animateCapturingOfPiece = { (completion:((Bool)->Void)?) in
            self.animateDisAppearanceOf(
                chessPieceView: pieceCaptured?.aninmationCopy,
                completion: completion
            )
        }
        
        //Moving Closure
        let animateMovingOfPiece = { (completion:((Bool)->Void)?) in
            self.animateMovingOf(
                chessPieceView: pieceToMove.aninmationCopy,
                to: move.endPosition,
                completion: completion
            )
            self.animateMovingOf(
                chessPieceView: rookMoved?.aninmationCopy,
                to: move.rookEndPosition,
                completion: nil
            )
        }
        
        //Promotion Closure
        let animatePromotion = { (completion:((Bool)->Void)?) in
            self.animateTranstion(
                from: pieceToMove.aninmationCopy,
                to: move.pieceToPromoteTo?.aninmationCopy,
                completion: completion
            )
        }
        
        
        //Execute the sequence of animations using the closures
        animateCapturingOfPiece {finished in
            animateMovingOfPiece {finished in rookMoved?.isHidden = false
                                              pieceToMove.isHidden = false
                animatePromotion{finished in move.pieceToPromoteTo?.isHidden = false}
            }
        }
    
    }
    
    func undo(move: ChessBoardView.Move,animate:Bool) {
        
        //Get the piece at the end position in case its a piece that is being demoted
        //(do this before calling undo)
        var pieceToDemote:ChessPieceView? = nil
        if move.pieceToDemoteTo != nil{
            pieceToDemote = self[move.endPosition.row,move.endPosition.col]!.chessPiece!

        }
        
        //undo the move
        super.undo(move: move)
        //if animate is false your done
        guard animate else {return}
        
        //get the resurrected piece
        let resurrectedPiece = self[move.positionOfPieceToCapture?.row,move.positionOfPieceToCapture?.col]?.chessPiece
        
        //Get handles on the pieces moved
        let rookMovedBack = self[move.rookStartPosition?.row,move.rookStartPosition?.col]?.chessPiece
        let pieceMovedBack = self[move.startPosition.row,move.startPosition.col]!.chessPiece!

        
        //temporarily hide the
        //1. piece moved back
        //2. extra rook moved back (if any)
        //3. piece resurrected to (if any)
        pieceMovedBack.isHidden = true
        rookMovedBack?.isHidden = true
        resurrectedPiece?.isHidden = true

        
        //unhide the appropriate animation copies
        pieceToDemote?.aninmationCopy.isHidden = false
        rookMovedBack?.aninmationCopy.isHidden = false
        
        //hide appropriate animation copies
        pieceMovedBack.aninmationCopy.isHidden = true
        resurrectedPiece?.aninmationCopy.isHidden = true
        
        //position the animation copy of the pieceMovedBack back to its endPosition
        pieceMovedBack.aninmationCopy.center = centerOfSquare(at: move.endPosition)!
        
        //Promotion Closure
        let animateDemotion = { (completion:((Bool)->Void)?) in
            self.animateTranstion(
                from: pieceToDemote?.aninmationCopy,
                to: pieceMovedBack.aninmationCopy,
                completion: completion
            )
        }
        
        //Moving Closure
        let animateMovingOfPiece = { (completion:((Bool)->Void)?) in
            self.animateMovingOf(
                chessPieceView: pieceMovedBack.aninmationCopy,
                to: move.startPosition,
                completion: completion
            )
            self.animateMovingOf(
                chessPieceView: rookMovedBack?.aninmationCopy,
                to: move.rookStartPosition,
                completion: nil
            )
        }
        
        //Capturing Closure
        let animateResurrectionOfPiece = { (completion:((Bool)->Void)?) in
            self.animateAppearanceOf(
                chessPieceView: resurrectedPiece?.aninmationCopy,
                completion: completion
            )
        }
        
        //Execute sequence of animations using closures
        animateDemotion{finished in pieceToDemote?.isHidden = true
                                    pieceMovedBack.aninmationCopy.isHidden = false
            animateMovingOfPiece {finished in rookMovedBack?.isHidden = false
                                              pieceMovedBack.isHidden = false
                animateResurrectionOfPiece{finished in resurrectedPiece?.isHidden = false }
            }
        }
        
    }
    
    

}
