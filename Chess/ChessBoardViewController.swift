//
//  ViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-10.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class ChessBoardViewController: UIViewController{

    //MARK: ChessBoardViewControllerDelegate
    
    var delegate:ChessBoardViewControllerDelegate!
    
    //MARK: - View
    @IBOutlet weak var chessBoardView: AnimatedChessBoardView!{
        didSet{
            //set up the chessBoard view before adding gesture recognizers
            //or else chessboard theme color is not applied
            setUpChessBoardView()
            setUpGestureRecognizers()
        }
    }
    
    //MARK: - Colors of the ChessBoardView
    var chessBoardTheme: ChessBoardTheme? = nil

    var lastSelectedSquare: ChessBoardSquareView? = nil
    
    //MARK: - Gesture Recognizers
    private func setUpGestureRecognizers(){
        if let chessBoardView = chessBoardView{
            //add single tap gesture recognizer to each ChessBoard square to enable selection
            for row in 0..<ChessBoardView.Dimensions.SquaresPerRow{
                for col in 0..<ChessBoardView.Dimensions.SquaresPerColumn{
                    chessBoardView[row,col]!.addGestureRecognizer(chessBoardSquareTapRecognizer)
                }
            }
            //add double tap gesture recognizer to the overall ChessBoard to enable deselection of squares
            chessBoardView.addGestureRecognizer(chessBoardDoubleTapRecognizer)
        }
    }
    
    private lazy var chessBoardDoubleTapRecognizer: UITapGestureRecognizer = { [unowned self] in
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChessBoardViewController.handleDoubleTap(recognizer:)))
        doubleTapRecognizer.numberOfTapsRequired = 1
        doubleTapRecognizer.numberOfTouchesRequired = 2
        return doubleTapRecognizer
    }()
        
    private var chessBoardSquareTapRecognizer: UITapGestureRecognizer{
        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChessBoardViewController.handleSingleTap(recognizer:)))
        singleTapRecognizer.numberOfTapsRequired = 1
        singleTapRecognizer.numberOfTouchesRequired = 1
        singleTapRecognizer.require(toFail: chessBoardDoubleTapRecognizer)
        return singleTapRecognizer
    }
    
    //MARK: - Gesture Handlers
    
    @objc private func handleSingleTap(recognizer: UITapGestureRecognizer){
        if recognizer.state == .ended {
            if let chessBoardSquare = recognizer.view as? ChessBoardSquareView{
                delegate.singleTapOccured(on: chessBoardSquare)
            }
        }
    }
    
    @objc private func handleDoubleTap(recognizer: UITapGestureRecognizer){
        if recognizer.state == .ended {
            if let _ = recognizer.view as? ChessBoardView{
                delegate.doubleTapOccured()
            }
        }
    }
    
    //MARK: - Highlighting/Selecting Squares
    func select(square: ChessBoardSquareView){
        deselectSelectedSquare()
        //select the newly selected square
        square.selected = true
        lastSelectedSquare = square
    }
    
    func deselectSelectedSquare(){
        //deselect the previously selected square
        lastSelectedSquare?.selected = false
        lastSelectedSquare = nil
    }
    
    //MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //set the colors of the chessBoardview is a chessboard theme is specified
    }
    
    private func setUpChessBoardView(){
        //ChessBoardView Setup
        if let chessBoardView = chessBoardView{
            //set the chess board colors
            if let chessBoardTheme = chessBoardTheme{
                chessBoardView.colorOfWhiteSquares = chessBoardTheme.whiteSquareColor
                chessBoardView.colorOfBlackSquares = chessBoardTheme.blackSquareColor
            }
            chessBoardView.setUpChessBoardView()
            //view.addSubview(chessBoardView)
        }
    }
    
    //MARK: Getting ChessPieceViews on Board
    internal var pieces:[ChessPieceView]{
        return chessBoardView.pieces
    }
    
    
    //MARK: Placing Several Pieces On Board
    func placePiecesAt(positions: [ChessBoardView.Position:ChessPieceView]){
        if let chessBoardView = chessBoardView, chessBoardView.isSetUp {
            for (position, chessPieceView) in positions{
                chessBoardView[position.row,position.col]!.chessPiece = chessPieceView
                //resize and position animation copy
                chessBoardView.resize(chessPieceView: chessPieceView.aninmationCopy, at: position)
                //if animate = false hide the animation copies
                if !delegate.shouldAnimate{
                    chessPieceView.aninmationCopy.isHidden = true
                }
            }
        }
        
    }
    
    // Animating the Performance and Undoing of Moves
    
    func perform(move: ChessBoardView.Move, animate: Bool, moveCompletionHandler:(()->Void)? = nil){
        //Get the piece to move in case its a pawn that is promoted
        //Get the piece captured as well
        //(do this before calling super.perform)
        let pieceToMove = chessBoardView[move.startPosition.row,move.startPosition.col]!.chessPiece!
        
        let pieceCaptured = chessBoardView[move.positionOfPieceToCapture?.row,move.positionOfPieceToCapture?.col]?.chessPiece
        
        //perfrom the move
        perform(move: move)
        
        //if animate is false your done
        guard animate else {moveCompletionHandler?();return}
        
        //Get a handle on the pieces moved
        let rookMoved = chessBoardView[move.rookEndPosition?.row,move.rookEndPosition?.col]?.chessPiece
        
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
            self.chessBoardView.animateDisAppearanceOf(
                chessPieceView: pieceCaptured?.aninmationCopy,
                completion: completion
            )
        }
        
        //Moving Closure
        let animateMovingOfPiece = { (completion:((Bool)->Void)?) in
            self.chessBoardView.animateMovingOf(
                chessPieceView: pieceToMove.aninmationCopy,
                to: move.endPosition,
                completion: completion
            )
            self.chessBoardView.animateMovingOf(
                chessPieceView: rookMoved?.aninmationCopy,
                to: move.rookEndPosition,
                completion: nil
            )
        }
        
        //Promotion Closure
        let animatePromotion = { (completion:((Bool)->Void)?) in
            self.chessBoardView.animateTranstion(
                from: pieceToMove.aninmationCopy,
                to: move.pieceToPromoteTo?.aninmationCopy,
                completion: completion
            )
        }
        
        
        //Execute the sequence of animations using the closures
        animateCapturingOfPiece {finished in
            animateMovingOfPiece {finished in rookMoved?.isHidden = false
                pieceToMove.isHidden = false
                animatePromotion {finished in move.pieceToPromoteTo?.isHidden = false
                    moveCompletionHandler?()
                }
            }
        }
        
    }
    
    func undo(move: ChessBoardView.Move,animate:Bool, completion:(()->Void)?) {
        
        //Get the piece at the end position in case its a piece that is being demoted
        //(do this before calling undo)
        var pieceToDemote:ChessPieceView? = nil
        if move.pieceToDemoteTo != nil{
            pieceToDemote = chessBoardView[move.endPosition.row,move.endPosition.col]!.chessPiece!
        }
        
        //undo the move
        undo(move: move)
        //if animate is false your done
        guard animate else {return}
        
        //get the resurrected piece
        let resurrectedPiece = chessBoardView[move.positionOfPieceToCapture?.row,move.positionOfPieceToCapture?.col]?.chessPiece
        
        //Get handles on the pieces moved
        let rookMovedBack = chessBoardView[move.rookStartPosition?.row,move.rookStartPosition?.col]?.chessPiece
        let pieceMovedBack = chessBoardView[move.startPosition.row,move.startPosition.col]!.chessPiece!
        
        
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
        pieceMovedBack.aninmationCopy.center = chessBoardView.centerOfSquare(at: move.endPosition)!
        
        //Promotion Closure
        let animateDemotion = { (completion:((Bool)->Void)?) in
            self.chessBoardView.animateTranstion(
                from: pieceToDemote?.aninmationCopy,
                to: pieceMovedBack.aninmationCopy,
                completion: completion
            )
        }
        
        //Moving Closure
        let animateMovingOfPiece = { (completion:((Bool)->Void)?) in
            self.chessBoardView.animateMovingOf(
                chessPieceView: pieceMovedBack.aninmationCopy,
                to: move.startPosition,
                completion: completion
            )
            self.chessBoardView.animateMovingOf(
                chessPieceView: rookMovedBack?.aninmationCopy,
                to: move.rookStartPosition,
                completion: nil
            )
        }
        
        //Capturing Closure
        let animateResurrectionOfPiece = { (completion:((Bool)->Void)?) in
            self.chessBoardView.animateAppearanceOf(
                chessPieceView: resurrectedPiece?.aninmationCopy,
                completion: completion
            )
        }
        
        //Execute sequence of animations using closures
        animateDemotion{finished in pieceToDemote?.isHidden = true
            pieceMovedBack.aninmationCopy.isHidden = false
            animateMovingOfPiece {finished in rookMovedBack?.isHidden = false
                pieceMovedBack.isHidden = false
                animateResurrectionOfPiece{finished in resurrectedPiece?.isHidden = false
                completion?()
                }
            }
        }
        
    }
    
    //Perfroms the move on the chessBoardView
    // -Moves and removes appropriate peices
    // -Moves rook if move is a castle
    // -Promotes piece if necessary
    private func perform(move:ChessBoardView.Move){
        
        //remove the captured piece if any (must be done before moving piece)
        _ = chessBoardView.removePiece(from: move.positionOfPieceToCapture)
        
        //moev the piece to the new position
        chessBoardView.movePiece(from: move.startPosition, endPosition: move.endPosition)
        
        
        //if a promotion occured promote the piece
        if let pieceToPromoteTo = move.pieceToPromoteTo{
            _ = chessBoardView.set(piece: pieceToPromoteTo, at: move.endPosition)
        }
        
        //move the rook if the move was a castle
        chessBoardView.movePiece(from: move.rookStartPosition, endPosition: move.rookEndPosition)
        
        //debugging
        print(move.description)
        
    }
    
    //Undoes a on the chessBoardView
    //-demotes piece if necessary
    //-moves piece back (and rook as well if castle)
    //-puts piece back if piece was captured during move
    private func undo(move:ChessBoardView.Move){
        //if a promotion occured demote the piece
        if nil != move.pieceToDemoteTo{
            _ = chessBoardView.set(piece: move.pieceToDemoteTo, at: move.endPosition)
        }
        
        //move the piece to the start position
        chessBoardView.movePiece(from: move.endPosition, endPosition: move.startPosition)
        
        //move the rook back if the move was a castle
        chessBoardView.movePiece(from: move.rookEndPosition, endPosition:move.rookStartPosition)
        
        //put back the captured piece if any (must be done after moving piece)
        _ = chessBoardView.set(piece: move.pieceCaptured, at: move.positionOfPieceToCapture)
    }
    
    
    
    
}

