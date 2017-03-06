//
//  ViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-10.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class ChessBoardViewController: UIViewController {
    //MARK: - Ratios
    struct Ratios{
        static let ChessBoardWidthToSuperViewWidth:CGFloat = 1
    }
    
    //MARK: - Position of Views
    //chessBoard
    lazy var chessBoardSize:CGSize = {
        let chessBoardSideLength = self.view.bounds.width * Ratios.ChessBoardWidthToSuperViewWidth
        return CGSize(width: chessBoardSideLength, height: chessBoardSideLength)
    }()
    lazy var ChessBoardFrame:CGRect = CGRect(center: self.view.bounds.mid, size: self.chessBoardSize)
    //PLayerPanels
    lazy var playerPanelSize:CGSize = {
        let playerPanelWidth = self.chessBoardSize.width
        let playerPanelHeight = (self.view.bounds.height - self.chessBoardSize.height)/2
        return CGSize(width: playerPanelWidth, height: playerPanelHeight)
    }()
    lazy var whitePlayerPanelFrame:CGRect = CGRect(lowerRight: self.view.bounds.lowerRight, size: self.playerPanelSize)
    lazy var blackPlayerPanelFrame:CGRect = CGRect(origin: self.view.bounds.origin, size: self.playerPanelSize)
    
    
    
    //MARK: - Model
    let chessGame: ChessGame = {
        let chessGame = ChessGame()
        chessGame.PlacePiecesInInitialPositions()
        return chessGame
    }()
    
    //MARK: - Animation
    var animate = true
    
    //MARK: -  Translation between Model and View
    private func modelPosition(from viewPosition: ChessBoardView.Position)->Position{
        return Position(row: viewPosition.row, col: viewPosition.col)!
    }
    
    private func viewPosition(from modelPosition: Position)->ChessBoardView.Position{
        return ChessBoardView.Position(row: modelPosition.row, col: modelPosition.col)!
    }
    
    private func viewPosition(of chessPiece:ChessPiece?)->ChessBoardView.Position?{
        return  chessPiece != nil ? viewPosition(from: chessPiece!.position) : nil
    }
    
    private func chessPieceView(from chessPiece:ChessPiece)->ChessPieceView{
        let viewPieceColor = viewChessPieceColor(from: chessPiece.color)
        let viewPieceType = chessPieceType(from: chessPiece.typeId)
        return ChessPieceView(color: viewPieceColor, type: viewPieceType!)
    }
    
    private func viewChessPieceColor(from chessPieceColor:ChessPieceColor)->ChessPieceView.ChessPieceColor{
        return ChessPieceView.ChessPieceColor(rawValue: chessPieceColor.rawValue)!
    }
    
    private func chessPieceType(from chessPieceTypeId:String)->ChessPieceView.ChessPieceType?{
        switch chessPieceTypeId {
        case "P":
            return ChessPieceView.ChessPieceType.Pawn
        case "R":
            return ChessPieceView.ChessPieceType.Rook
        case "H":
            return ChessPieceView.ChessPieceType.Knight_R
        case "B":
            return ChessPieceView.ChessPieceType.Bishop
        case "Q":
            return ChessPieceView.ChessPieceType.Queen
        case "K":
            return ChessPieceView.ChessPieceType.King
        default:
            return nil
        }
    }
    
    
    //MARK: - View
    var chessBoardView: AnimatedChessBoardView! = nil{
        didSet{
            setUpGestureRecognizers()
        }
    }
    var whitePlayerPanel: PlayerPanelView! = nil
    var blackPlayerPanel: PlayerPanelView! = nil
    
    private var lastSelectedSquare: ChessBoardSquareView? = nil
    
    //MARK: - Gesture Recognizers
    private func setUpGestureRecognizers(){
        if let chessBoardView = chessBoardView{
            //add single tap gesture recognizer to each ChessBoard square to enable selction
            for row in 0..<ChessBoardView.Dimensions.SquaresPerRow{
                for col in 0..<ChessBoardView.Dimensions.SquaresPerColumn{
                    chessBoardView[row,col].addGestureRecognizer(chessBoardSquareTapRecognizer)
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
        }else if let lastSelectedSquare = lastSelectedSquare{//verify whether or not another (necessarily different square was previously selcted
            
            
            //prepare old and new position parameters to call movePiece
            let oldPosition = modelPosition(from: lastSelectedSquare.position)
            let newPosition = modelPosition(from: tappedChessBoardSquare.position)
            
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
            
            
            //ask the model to attempt the move and verify if it is legal in doing so
            //if it is legal the move is executed in the model and view is updated accordingly
            let (move,opponentInCheck,outcome) = chessGame.movePiece(from: oldPosition, to: newPosition)
            if let successfulMove = move {
                //if the move is legal deselect the previously selected square
                deselectSelectedSquare()
                
                //Get the Position of the captured piece (if any)
                let positionOfPieceCaptured = viewPosition(of: move?.pieceCaptured)
                //move the piece in the BoardView
                let (_, pieceCaptured) = movePiece(from: lastSelectedSquare.position,
                                                   to: tappedChessBoardSquare.position,
                                                   positionOfPieceCaptured: positionOfPieceCaptured)
                //if move was a castle
                if let castle = successfulMove as? Castle{
                    //also move rook back
                    let rookStartPosition = viewPosition(from: castle.initialRookPosition)
                    let rookEndPosition = viewPosition(from: castle.finalRookPosition)
                    _ = movePiece(from: rookStartPosition, to: rookEndPosition)
                }

                //if a piece was captured update the graveyardView so players can keep track of what pieces were captured
                if pieceCaptured != nil{
                    addChessPieceToGraveYard(chessPieceView: pieceCaptured!)
                }
                //deselect the last square selected after the move is complete
                deselectSelectedSquare()
            }
            if let outcome = outcome{
                switch outcome {
                case OutCome.Win(let color):
                    print("Check Mate!")
                    print(outcome)
                //TODO: Animate "Check Mate!" Label Over screen
                //TODO: Animate "White Win!" or "Black Win!"  Label Over screen (depending on color)
                    break
                case OutCome.Draw:
                    print(outcome)
                    //TODO: Animate "Draw!" Label Over screen
                    break
                }
            } else if opponentInCheck == true {
                print("Check to \(chessGame.colorWhoseTurnItIs) King!")
                //TODO: Animate "Check to (White/Black)!" Label Over screen
            }
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
                    undoLastMove()
                }
            }
        }
    }
    
    //MARK: - Undo Move
    
    private func undoLastMove(){
        //otherwise undo the last move if any
        if let lastMove = chessGame.undoLastMove(){
            //translate the positions to view Positions
            let startPosition = viewPosition(from: lastMove.startPosition)
            let endPosition = viewPosition(from: lastMove.endPosition)
            //Get piece to put back tuple
            //Create a new instance of a chess piece view
            let putPieceBack:(view:ChessPieceView,ChessBoardView.Position)? = (lastMove.pieceCaptured != nil) ?
                (chessPieceView(from: lastMove.pieceCaptured!),viewPosition(from: lastMove.pieceCaptured!.position)):
                nil
            //move the piece back to its startPosition and put a piece back if one was captured during the move
            _ = movePiece(from: endPosition, to: startPosition, putPieceBack:putPieceBack)

            //if move was a castle
            if let castle = lastMove as? Castle{
                //also move rook back
                let rookStartPosition = viewPosition(from: castle.initialRookPosition)
                let rookEndPosition = viewPosition(from: castle.finalRookPosition)
                _ = movePiece(from: rookEndPosition, to: rookStartPosition)

            }
            //if there was a piece putback remove it from the graveYard it came from
            if let putPieceBack = putPieceBack{
                let removeSucceeded = RemoveChessPieceFromGraveYard(chessPieceView: putPieceBack.view)
                if !removeSucceeded{
                    print("Failed to remove piece from Grave Yard!")
                }
            }
            
        }
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
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func setUpView(){
        //ChessBoardView Setup
        chessBoardView = AnimatedChessBoardView(frame: ChessBoardFrame, colorOfWhiteSquares: UIColor.white, colorOfBlackSquares: UIColor.green)
        if let chessBoardView = chessBoardView{
            chessBoardView.setUpChessBoardView()
            view.addSubview(chessBoardView)
            placePiecesInStartingPosition()
        }
        //whitePlayerPanel Setup
        whitePlayerPanel = PlayerPanelView(frame: whitePlayerPanelFrame, playerColor: ChessPieceColor.White)
        //BlackPlayerPanel Setup
        blackPlayerPanel = PlayerPanelView(frame: blackPlayerPanelFrame, playerColor: ChessPieceColor.Black)
        if let whitePlayerPanel = whitePlayerPanel, let blackPlayerPanel = blackPlayerPanel{
            view.addSubview(whitePlayerPanel)
            view.addSubview(blackPlayerPanel)
        }
    }
    
    
    //MARK: - Moving Pieces On ChessBoard View
    
    func movePiece(from oldPostion: ChessBoardView.Position,
                   to newPosition: ChessBoardView.Position,
                   positionOfPieceCaptured:ChessBoardView.Position? = nil,
                   putPieceBack:(ChessPieceView,ChessBoardView.Position)?=nil,
                   animate:Bool=true)->(Bool, ChessPieceView?){
        return chessBoardView.movePiece(from: oldPostion,
                                        to: newPosition,
                                        positionOfPieceCaptured: positionOfPieceCaptured,
                                        putPieceBack: putPieceBack,
                                        animate: animate)
    }
    
    
    //MARK: - Adding and Removing Captured Pieces to GraveYardView
    
    //whites peices go to the black players graveYard
    //black pieces go to the white players graveYard
    private func addChessPieceToGraveYard(chessPieceView:ChessPieceView){
        //get the appropriate player's panel
        let playerPanel = chessPieceView.chessPieceIdentifier.color == .White ? blackPlayerPanel :whitePlayerPanel
        playerPanel?.graveYardView.add(chessPieceView: chessPieceView)
    }
    
    private func RemoveChessPieceFromGraveYard(chessPieceView:ChessPieceView)->Bool{
        //get the appropriate player's panel
        let playerPanel = chessPieceView.chessPieceIdentifier.color == .White ? blackPlayerPanel :whitePlayerPanel
        return playerPanel?.graveYardView.remove(chessPieceView: chessPieceView) ?? false
    }
    
       
    //MARK: - Initial Placement of Pieces in View
    
    private func placePiecesInStartingPosition(){
        if let chessBoardView = chessBoardView, chessBoardView.isSetUp {
            let whiteRowRange = 0...1
            let blackRowRange = 6...7
            for row in [whiteRowRange, blackRowRange].joined(){
                for col in 0..<ChessBoardView.Dimensions.SquaresPerColumn{
                    let position = ChessBoardView.Position(row:row,col:col)!
                    if let chessPiece = pieceInitiallyAt[position]{
                        chessBoardView[row,col].chessPiece = chessPiece
                        //resize and position animation copy
                        chessBoardView.resize(chessPieceView: chessPiece.aninmationCopy, at: position)
                    }
                }
            }
        }
    }
    
    private let pieceInitiallyAt: [ChessBoardView.Position:ChessPieceView] = [
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

