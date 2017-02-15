//
//  ViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-10.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class ChessBoardViewController: UIViewController {
    //MARK: - View
    var chessBoard: ChessBoardView! = nil{
        didSet{
            setUpGestureRecognizers()
        }
    }
    
    private var lastSelectedSquare: ChessBoardSquareView? = nil
    
    //MARK: - Gesture Recognizers
    private func setUpGestureRecognizers(){
        if let chessBoard = chessBoard{
            //add single tap gesture recognizer to each ChessBoard square to enable selction
            for row in 0..<ChessBoardView.Dimensions.SquaresPerRow{
                for col in 0..<ChessBoardView.Dimensions.SquaresPerColumn{
                    chessBoard[row,col].addGestureRecognizer(chessBoardSquareTapRecognizer)
                }
            }
            //add double tap gesture recognizer to the overall ChessBoard to enable deselection of squares
            chessBoard.addGestureRecognizer(chessBoardDoubleTapRecognizer)
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
                singleTapOccured(on: chessBoardSquare)
            }
        }
    }
    
    private func singleTapOccured(on tappedChessBoardSquare: ChessBoardSquareView){
        //verify if the position of the previously selected matches the tapped square
        if tappedChessBoardSquare == lastSelectedSquare{
            //if they match deselect the square
            deselectSelectedSquare()
        }else if let lastSelectedSquare = lastSelectedSquare{//verify whether or not square was previously selcted
            
            //TODO: - verify the move is legal and update the model if so
            //if the move is legal deselect the previously selected square
            
            deselectSelectedSquare()
            let (_, _) = movePiece(from: lastSelectedSquare.position, to: tappedChessBoardSquare.position)
            deselectSelectedSquare()
            
        } else if tappedChessBoardSquare.isOccupied {
            //otherwise if no square was previously selected
            //and there is a piece on the tapped square, select the square
            select(square: tappedChessBoardSquare)
        }
    }
    
    
    @objc private func handleDoubleTap(recognizer: UITapGestureRecognizer){
        if recognizer.state == .ended {
            if let _ = recognizer.view as? ChessBoardView{
                deselectSelectedSquare()
            }
        }
    }
    
    //MARK - Highlighting/Selecting Squares
    private func select(square: ChessBoardSquareView){
        deselectSelectedSquare()
        //select the newly selected square
        square.selected = true
        lastSelectedSquare = square
    }
    
    private func deselectSelectedSquare(){
        //deselect the previously selected square
        lastSelectedSquare?.selected = false
        lastSelectedSquare = nil
    }
    
    
    
    
    
    
    //MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func setUpView(){
        let origin = CGPoint(x: 0, y:0)
        let frame = CGRect(origin: origin, size: view.bounds.size)
        chessBoard = ChessBoardView(frame: frame, colorOfWhiteSquares: UIColor.white, colorOfBlackSquares: UIColor.green)
        if let chessBoard = chessBoard{
            chessBoard.setUpChessBoard()
            view.addSubview(chessBoard)
            placePiecesInStartingPosition()
        }
    }
    
    
    //MARK: - Moving Pieces
    
    func movePiece(from oldPostion: ChessBoardView.SquarePosition, to newPosition: ChessBoardView.SquarePosition)->(Bool, ChessPieceView?){
        return chessBoard.movePiece(from: oldPostion, to: newPosition)
    }
    
    func removePiece(from position: ChessBoardView.SquarePosition)->ChessPieceView?{
        return chessBoard.removePiece(from: position)
    }
    
    func set(piece: ChessPieceView?, at position: ChessBoardView.SquarePosition)->ChessPieceView?{
        return chessBoard.set(piece: piece, at: position)
    }
    
    
    
    //MARK: - Initial Placement of Pieces
    
    private func placePiecesInStartingPosition(){
        if let chessBoard = chessBoard, chessBoard.isSetUp {
            let whiteRowRange = 0...1
            let blackRowRange = 6...7
            for row in [whiteRowRange, blackRowRange].joined(){
                for col in 0..<ChessBoardView.Dimensions.SquaresPerColumn{
                    chessBoard[row,col].chessPiece = pieceInitiallyAt[ChessBoardView.SquarePosition(row:row,col:col)!]
                }
            }
        }
    }
    
    private let pieceInitiallyAt: [ChessBoardView.SquarePosition:ChessPieceView] = [
        //Initial position of Black Pieces
        ChessBoardView.SquarePosition(row: 0,col: 0)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.Rook),
        ChessBoardView.SquarePosition(row: 0,col: 1)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.Knight_L),
        ChessBoardView.SquarePosition(row: 0,col: 2)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.Bishop),
        ChessBoardView.SquarePosition(row: 0,col: 3)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.Queen),
        ChessBoardView.SquarePosition(row: 0,col: 4)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.King),
        ChessBoardView.SquarePosition(row: 0,col: 5)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.Bishop),
        ChessBoardView.SquarePosition(row: 0,col: 6)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.Knight_R),
        ChessBoardView.SquarePosition(row: 0,col: 7)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.Rook),
        ChessBoardView.SquarePosition(row: 1,col: 0)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.Pawn),
        ChessBoardView.SquarePosition(row: 1,col: 1)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.Pawn),
        ChessBoardView.SquarePosition(row: 1,col: 2)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.Pawn),
        ChessBoardView.SquarePosition(row: 1,col: 3)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.Pawn),
        ChessBoardView.SquarePosition(row: 1,col: 4)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.Pawn),
        ChessBoardView.SquarePosition(row: 1,col: 5)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.Pawn),
        ChessBoardView.SquarePosition(row: 1,col: 6)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.Pawn),
        ChessBoardView.SquarePosition(row: 1,col: 7)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.Pawn),
        //Initial position of White Pieces
        ChessBoardView.SquarePosition(row: 6,col: 0)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.Pawn),
        ChessBoardView.SquarePosition(row: 6,col: 1)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.Pawn),
        ChessBoardView.SquarePosition(row: 6,col: 2)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.Pawn),
        ChessBoardView.SquarePosition(row: 6,col: 3)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.Pawn),
        ChessBoardView.SquarePosition(row: 6,col: 4)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.Pawn),
        ChessBoardView.SquarePosition(row: 6,col: 5)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.Pawn),
        ChessBoardView.SquarePosition(row: 6,col: 6)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.Pawn),
        ChessBoardView.SquarePosition(row: 6,col: 7)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.Pawn),
        ChessBoardView.SquarePosition(row: 7,col: 0)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.Rook),
        ChessBoardView.SquarePosition(row: 7,col: 1)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.Knight_L),
        ChessBoardView.SquarePosition(row: 7,col: 2)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.Bishop),
        ChessBoardView.SquarePosition(row: 7,col: 3)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.Queen),
        ChessBoardView.SquarePosition(row: 7,col: 4)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.King),
        ChessBoardView.SquarePosition(row: 7,col: 5)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.Bishop),
        ChessBoardView.SquarePosition(row: 7,col: 6)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.Knight_R),
        ChessBoardView.SquarePosition(row: 7,col: 7)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.Rook)
    ]
}

