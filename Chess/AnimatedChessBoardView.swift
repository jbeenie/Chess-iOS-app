////
////  AnimatedChessBoardView.swift
////  Chess
////
////  Created by Jeremie Benhamron on 2017-03-01.
////  Copyright © 2017 beenie.inc. All rights reserved.
////
//
//import UIKit
//
//class AnimatedChessBoardView: ChessBoardView {
//
//    struct Animation{
//        static let moveDuration: TimeInterval = 0.4
//        static let moveDelay: TimeInterval = 0.2
//        static let fadeDuration: TimeInterval = 0.2
//        static let fadeDelay: TimeInterval = 0
//        
//    }
//
//    
//    //Animation Constants
//    struct Animation{
//        static let moveDuration: TimeInterval = 0.4
//        static let moveDelay: TimeInterval = 0.2
//        static let fadeDuration: TimeInterval = 0.2
//        static let fadeDelay: TimeInterval = 0
//        
//        //Closure for executing Animations
//        //create a closure which executes the animation responsible for moving of the chessPiece
//        let movingPiece: (Bool)->() = {finished in UIView.animate(withDuration: Animation.moveDuration,
//                                                                  delay: Animation.moveDelay,
//                                                                  options: [UIViewAnimationOptions.curveEaseInOut],
//                                                                  animations: {pieceToMoveCopy.center = self.centerOfSquare(at: newPosition)},
//                                                                  completion: completionHandler)
//        }
////    }
//    
//    private func animateChessPiece(_ chessPiece: ChessPieceView, movingFrom oldPosition: ChessBoardView.Position, to newPosition: ChessBoardView.Position, pieceCaptured: ChessPieceView?){
//        
//        //hide the chess piece view
//        chessPiece.isHidden = true
//        
//        //Create a copy of the moving chess Pieces for animation
//        let pieceToMoveCopy = ChessPieceView(chessPieceView: chessPiece)
//        //position and resize it and add it as a subview of the chess board
//        _ = self.set(piece: pieceToMoveCopy, at: oldPosition)
//        _ = self.removePiece(from: oldPosition)
//        pieceToMoveCopy.center = centerOfSquare(at: oldPosition)
//        self.addSubview(pieceToMoveCopy)
//        
//        //create completion handler for the animation responsible for moving the piece
//        let completionHandler:(Bool)->() = {_ in
//            //remove the animation copies from the chessboard lists of subviews
//            pieceToMoveCopy.removeFromSuperview()
//            pieceCaptured?.removeFromSuperview()
//            //unhide the original chess piece view
//            chessPiece.isHidden = false
//        }
//        
//        //create a closure which executes the animation responsible for moving of the chessPiece
//        let movingAnimationClosure: (Bool)->() = {finished in UIView.animate(withDuration: Animation.moveDuration,
//                                                                             delay: Animation.moveDelay,
//                                                                             options: [UIViewAnimationOptions.curveEaseInOut],
//                                                                             animations: {pieceToMoveCopy.center = self.centerOfSquare(at: newPosition)},
//                                                                             completion: completionHandler)
//        }
//        
//        if pieceCaptured != nil{
//            //make a copy of the piece captured for animation
//            let pieceCapturedCopy = ChessPieceView(chessPieceView: pieceCaptured!)
//            pieceCapturedCopy.center = centerOfSquare(at: oldPosition)
//            self.addSubview(pieceCapturedCopy)
//            UIView.animate(withDuration: Animation.fadeDuration,
//                           delay: Animation.fadeDelay,
//                           options: [UIViewAnimationOptions.curveLinear],
//                           animations: {pieceCapturedCopy.alpha = 0},
//                           completion: movingAnimationClosure)
//        }
//        
//        
//        
//    }
//    
//}
