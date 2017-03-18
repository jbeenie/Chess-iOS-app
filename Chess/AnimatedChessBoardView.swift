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

    func animateMovingOf(chessPieceView:ChessPieceView?, to newPosition:Position?, completion: ((Bool) -> Void)? = nil){
        
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

    func animateDisAppearanceOf(chessPieceView:ChessPieceView?, completion: ((Bool) -> Void)? = nil){
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
    
    func animateAppearanceOf(chessPieceView:ChessPieceView?, completion: ((Bool) -> Void)? = nil){
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
    
    func animateTranstion(from disappearingChessPieceView:ChessPieceView?, to appearingChessPieceView:ChessPieceView?, completion: ((Bool)->Void)? = nil){
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
    

}
