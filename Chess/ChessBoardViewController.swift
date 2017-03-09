//
//  ViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-10.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class ChessBoardViewController: UIViewController,PromotionDelegate{

    //MARK: - Animation
    var animate = true
    
    //MARK: - Model
    let chessGame: ChessGame = {
        let chessGame = ChessGame()
        chessGame.PlacePiecesInInitialPositions()
        return chessGame
    }()
    
    
    //MARK: - SubViewControllers
    
   
    private var blackChessPieceGraveYardViewController: BlackChessPieceGraveYardViewController!
    
    private var whiteChessPieceGraveYardViewController: WhiteChessPieceGraveYardViewController!
    
    
    //MARK: - View
    
    @IBOutlet weak var chessBoardView: AnimatedChessBoardView!{
        didSet{
            setUpGestureRecognizers()
        }
    }

    private var lastSelectedSquare: ChessBoardSquareView? = nil
    
    //MARK: - Promition 
    
    //Conform To Promotion Delegate
    func getPieceToPromoteTo(ofColor color: ChessPieceColor, at position: Position, on board:ChessBoard)->ChessPiece{
        //TODO: Initiate PopOver Segue and get choice from User
        //Use color to display pieces of appropriate color
        //get type ID
        
        return Queen(color: color, position: position, chessBoard: board)
    }
    
    
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
                singleTapOccured(on: chessBoardSquare)
            }
        }
    }
    
    private func singleTapOccured(on tappedChessBoardSquare: ChessBoardSquareView){

        //verify if the position of the previously selected matches the tapped square
        if tappedChessBoardSquare == lastSelectedSquare{
            //if they match deselect the square
            deselectSelectedSquare()
        
        //else verify whether or not another (necessarily different square was previously selcted
        }else if let lastSelectedSquare = lastSelectedSquare{
            
            
            //prepare old and new position parameters to call movePiece
            let oldPosition = ModelViewTranslation.modelPosition(from: lastSelectedSquare.position)
            let newPosition = ModelViewTranslation.modelPosition(from: tappedChessBoardSquare.position)
            
            //if that square is occupied by a piece of the same color
            //delect the previously selected square and
            //select the square that has just been tapped
            if  let colorOfPiece1 = chessGame.piece(at: oldPosition)?.color,
                let colorOfPiece2 = chessGame.piece(at: newPosition)?.color,
                colorOfPiece1 == colorOfPiece2{
                deselectSelectedSquare()
                select(square: tappedChessBoardSquare)
                return
            }
            
            //Attempt to perform the move and return if the move fails
            guard let (move,opponentInCheck,outcome) = performMove(from: oldPosition, to: newPosition) else {return}
            
            //now the view must be updated accordingly
            //deselect the previously selected square
            deselectSelectedSquare()

            //if a piece was captured update the graveyardView so players can keep track of what pieces were captured
            if let pieceCaptured =  move.pieceCaptured{
                _ = addChessPieceToGraveYard(chessPiece: pieceCaptured)
            }
            
            //give the user visual feedback based on the outcome of the move
            //tells players:
            //1. when king is in check
            //2. check mate occurs
            //3. reach a draw
            giveUserFeedBackBased(on: outcome, opponentInCheck: opponentInCheck)
            
        } else if tappedChessBoardSquare.isOccupied {
            //otherwise if no square was previously selected
            //and there is a piece on the tapped square, select the square
            //verify that the piece in the square is of the appropriate color,
            //i.e. that it is that color's turn to play
            let colorOfTappedPiece = tappedChessBoardSquare.chessPiece!.chessPieceIdentifier.color
            if colorOfTappedPiece.rawValue == chessGame.colorWhoseTurnItIs.rawValue{
                select(square: tappedChessBoardSquare)
            }
        }
    }
    
    
    @objc private func handleDoubleTap(recognizer: UITapGestureRecognizer){
        if recognizer.state == .ended {
            if let _ = recognizer.view as? ChessBoardView{
                //if a square is selected deselect
                if lastSelectedSquare != nil{
                    deselectSelectedSquare()
                }else {//otherwise undo the last move
                    let lastMove = undoLastMove()
                    //if a piece was put back remove it from the graveyard
                    if let pieceResurrected = lastMove?.pieceCaptured{
                        removeChessPieceFromGraveYard(chessPiece: pieceResurrected)
                    }
                }
            }
        }
    }

    
    
    //MARK: Performing and Undoing Move
    
    //MARK: Perform Move
    private func performMove(from oldPosition: Position,to newPosition: Position)->((Move, Bool, Outcome?)?){
        //ask the model to attempt the move and verify if it is legal in doing so
        //if the move is legal it is executed in the model
        guard let (move,opponentInCheck,outcome) = chessGame.movePiece(from: oldPosition, to: newPosition) else{return nil}
        
        //Translate the model move into view move
        let viewMove = ModelViewTranslation.chessBoardViewMove(from: move)
        
        //move the piece in the ChessBoardView
        chessBoardView.perform(move: viewMove,animate:animate)
        //return the appropriate information
        return (move,opponentInCheck,outcome)
    }
    
    //MARK: Undo Move
    private func undoLastMove()->Move?{
        //otherwise undo the last move if any
        if let lastMove = chessGame.undoLastMove(){
            //translate move to view move
            let lastViewMove = ModelViewTranslation.chessBoardViewMove(from: lastMove)
            //undo the last move on the chessBoardView
            chessBoardView.undo(move: lastViewMove, animate:animate)
            return lastMove
        }
        return nil
    }

    
    //MARK: - Highlighting/Selecting Squares
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
        //Set yourself as the promotion delegate of the chessgame
        chessGame.promotionDelegate = self
    }
    
    private func setUpView(){
        //ChessBoardView Setup
        if let chessBoardView = chessBoardView{
            chessBoardView.setUpChessBoardView()
            //view.addSubview(chessBoardView)
            placePiecesAtStartingPosition()
        }
    }
    
    //MARK: - User FeedBack
    
    private func giveUserFeedBackBased(on outcome: Outcome?, opponentInCheck:Bool){
        if let outcome = outcome{
            switch outcome {
            //TODO: USE Color when announcing outcome
            case Outcome.Win(_):
                print("Check Mate!")
                print(outcome)
                //TODO: Animate "Check Mate!" Label Over screen
                //TODO: Animate "White Win!" or "Black Win!"  Label Over screen (depending on color)
                break
            case Outcome.Draw:
                print(outcome)
                //TODO: Animate "Draw!" Label Over screen
                break
            }
        } else if opponentInCheck == true {
            print("Check to \(chessGame.colorWhoseTurnItIs) King!")
            //TODO: Animate "Check to (White/Black)!" Label Over screen
        }
    }
    
    //MARK: - Navigation
    //Embed SubViewControllers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "BlackChessPieceGraveYardViewController"){
            blackChessPieceGraveYardViewController = segue.destination as! BlackChessPieceGraveYardViewController
        }else if (segue.identifier == "WhiteChessPieceGraveYardViewController"){
            whiteChessPieceGraveYardViewController = segue.destination as! WhiteChessPieceGraveYardViewController
        }
    }
    
    
    //MARK: - Adding and Removing Captured Pieces to GraveYardView
    
    //whites peices go to the black players graveYard
    //black pieces go to the white players graveYard
    private func addChessPieceToGraveYard(chessPiece:ChessPiece){
        let chessPieceGraveYardViewController = chessPiece.color == .Black ? whiteChessPieceGraveYardViewController : blackChessPieceGraveYardViewController
        _=chessPieceGraveYardViewController.add(chessPiece: chessPiece)
    }
    
    private func removeChessPieceFromGraveYard(chessPiece:ChessPiece){
        let chessPieceGraveYardViewController = chessPiece.color == .Black ? whiteChessPieceGraveYardViewController : blackChessPieceGraveYardViewController
        _=chessPieceGraveYardViewController.remove(chessPiece: chessPiece)
    }
    
       
    //MARK: - Initial Placement of Pieces in View
    
    private func placePiecesAtStartingPosition(){
        placePiecesAt(positions: initialChessPiecePositions)
    }
    
    private func placePiecesAt(positions: [ChessBoardView.Position:ChessPieceView]){
        if let chessBoardView = chessBoardView, chessBoardView.isSetUp {
            for (position, chessPieceView) in positions{
                chessBoardView[position.row,position.col]!.chessPiece = chessPieceView
                //resize and position animation copy
                chessBoardView.resize(chessPieceView: chessPieceView.aninmationCopy, at: position)
                //if animate = false hide the animation copies
                if !animate{
                    chessPieceView.aninmationCopy.isHidden = true
                }
            }
        }
        
    }
    
    private let initialChessPiecePositions: [ChessBoardView.Position:ChessPieceView] = [
        //Initial position of Black Pieces
        ChessBoardView.Position(row: 0,col: 0)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.Rook),
        ChessBoardView.Position(row: 0,col: 1)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.Knight_R),
        ChessBoardView.Position(row: 0,col: 2)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.Bishop),
        ChessBoardView.Position(row: 0,col: 3)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.Queen),
        ChessBoardView.Position(row: 0,col: 4)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.King),
        ChessBoardView.Position(row: 0,col: 5)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.Bishop),
        ChessBoardView.Position(row: 0,col: 6)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.Knight_R),
        ChessBoardView.Position(row: 0,col: 7)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.Rook),
        ChessBoardView.Position(row: 1,col: 0)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.Pawn),
        ChessBoardView.Position(row: 1,col: 1)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.Pawn),
        ChessBoardView.Position(row: 1,col: 2)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.Pawn),
        ChessBoardView.Position(row: 1,col: 3)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.Pawn),
        ChessBoardView.Position(row: 1,col: 4)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.Pawn),
        ChessBoardView.Position(row: 1,col: 5)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.Pawn),
        ChessBoardView.Position(row: 1,col: 6)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.Pawn),
        ChessBoardView.Position(row: 1,col: 7)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.Black, type: ChessPieceView.ChessPieceType.Pawn),
        //Initial position of White Pieces
        ChessBoardView.Position(row: 6,col: 0)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.Pawn),
        ChessBoardView.Position(row: 6,col: 1)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.Pawn),
        ChessBoardView.Position(row: 6,col: 2)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.Pawn),
        ChessBoardView.Position(row: 6,col: 3)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.Pawn),
        ChessBoardView.Position(row: 6,col: 4)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.Pawn),
        ChessBoardView.Position(row: 6,col: 5)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.Pawn),
        ChessBoardView.Position(row: 6,col: 6)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.Pawn),
        ChessBoardView.Position(row: 6,col: 7)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.Pawn),
        ChessBoardView.Position(row: 7,col: 0)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.Rook),
        ChessBoardView.Position(row: 7,col: 1)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.Knight_R),
        ChessBoardView.Position(row: 7,col: 2)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.Bishop),
        ChessBoardView.Position(row: 7,col: 3)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.Queen),
        ChessBoardView.Position(row: 7,col: 4)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.King),
        ChessBoardView.Position(row: 7,col: 5)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.Bishop),
        ChessBoardView.Position(row: 7,col: 6)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.Knight_R),
        ChessBoardView.Position(row: 7,col: 7)!: ChessPieceView(color: ChessPieceView.ChessPieceColor.White, type: ChessPieceView.ChessPieceType.Rook)
    ]
}

