//
//  ChessGameViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-13.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class ChessGameViewController: UIViewController,PromotionDelegate,UIPopoverPresentationControllerDelegate,ChessBoardViewControllerDelegate{

    struct StoryBoard{
        static let PromotionChoicesVCID = "PromotionPopOver"
        static let BlackChessPieceGraveYardViewController = "BlackChessPieceGraveYardViewController"
        static let WhiteChessPieceGraveYardViewController = "WhiteChessPieceGraveYardViewController"
        static let BlackTimerViewController = "BlackTimerViewController"
        static let WhiteTimerViewController = "WhiteTimerViewController"
        static let ChessBoardViewController = "ChessBoardViewController"
    }
    
    struct Ratios{
        static let popOverWidthToChessBoardWidth:CGFloat = 0.5
        static let popOverWidthToPopOverHeight:CGFloat = 4
    }
    
    //MARK: - Properties
    
    //MARK: Animation
    let animate = true
    
    //MARK: Board
    private var chessBoardView:ChessBoardView!{
        return chessBoardViewController.chessBoardView
    }
    private var lastSelectedSquare: ChessBoardSquareView?{
        return chessBoardViewController.lastSelectedSquare
    }
    
    
    //MARK: - Model
    //MARK: Chess game
    let chessGame: ChessGame = {
        let chessGame = ChessGame()
        chessGame.PlacePiecesInInitialPositions()
        return chessGame
    }()
    
    
    //MARK: Chess Timer
    let timersEnabled = true
    let initialTime: Int = 120 //seconds
    
    //MARK: - SubViewControllers
    //MARK: GRAVEYARDS
    private var blackChessPieceGraveYardViewController: BlackChessPieceGraveYardViewController!
    private var whiteChessPieceGraveYardViewController: WhiteChessPieceGraveYardViewController!
    //MARK: TIMERS
    private var whiteTimerViewController:WhiteTimerViewController?
    private var blackTimerViewController:BlackTimerViewController?
    //MARK: Chessboard
    private var chessBoardViewController:ChessBoardViewController!
    
    //MARK: - Promition
    
    //MARK: Conform To Promotion Delegate
    func getPieceToPromoteTo(ofColor color: ChessPieceColor, at position: Position){
        //Translate arguments from model to view counterparts
        let viewColor = ModelViewTranslation.viewChessPieceColor(from: color)
        let viewPosition = ModelViewTranslation.viewPosition(from: position)
        
        //Create the promotion choices pop over VC to ask user what piece
        //to promote to
        let promotionChoicesPopOverVC = createPromotionChoicesPopOverVC(for: viewColor, position: position)
        
        // show the pop over and make it point to the chess piece being promoted
        if let chessBoardSquareToPointTo = chessBoardView[viewPosition.row,viewPosition.col]{
            show(promotionChoicesPopOver: promotionChoicesPopOverVC, pointingTo: chessBoardSquareToPointTo, of: viewColor)
        }
    }
    
    //MARK: Creating Promotion Choices PopOver VC
    
    private var promotionChoicesPopOverSize:CGSize{
        let width:CGFloat = chessBoardView.frame.width * Ratios.popOverWidthToChessBoardWidth
        let height:CGFloat = width / Ratios.popOverWidthToPopOverHeight
        return CGSize(width:width, height:height)
    }
    
    private func createPromotionChoicesPopOverVC(for color:ChessPieceView.ChessPieceColor, position: Position)->PromotionChoicesViewController{
        let promotionChoicesPopOverVC = storyboard?.instantiateViewController(withIdentifier: StoryBoard.PromotionChoicesVCID) as! PromotionChoicesViewController
        promotionChoicesPopOverVC.colorOfPieces = color
        promotionChoicesPopOverVC.completionHandler = (promotionCompletionHandler,position)
        promotionChoicesPopOverVC.preferredContentSize = promotionChoicesPopOverSize
        return promotionChoicesPopOverVC
    }
    
    //MARK: Presenting the pop over
    private func show(promotionChoicesPopOver: PromotionChoicesViewController,pointingTo chessBoardSquare:ChessBoardSquareView, of color: ChessPieceView.ChessPieceColor){
        //set the pop over VC's presentation style to popover
        promotionChoicesPopOver.modalPresentationStyle = .popover
        //configure the popoverPresentationController
        guard let popoverPresentationController = promotionChoicesPopOver.popoverPresentationController else{ return }
        
        //make it point to the chessPiece being promoted
        popoverPresentationController.sourceView = chessBoardSquare
        popoverPresentationController.sourceRect = chessBoardSquare.bounds
        
        //orient the pop over appropriately
        let permittedArrowDirection: UIPopoverArrowDirection = (color == .White) ? .down : .up
        popoverPresentationController.permittedArrowDirections = [permittedArrowDirection]
        //set yourself as the delegate of the popoverPresentationController
        popoverPresentationController.delegate = self
        //finally show the pop over
        present(promotionChoicesPopOver, animated: true)
    }
    
    //MARK:Implementation of UIPopoverPresentationControllerDelegate methods
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        popoverPresentationController.backgroundColor = UIColor.darkGray
        print (popoverPresentationController.presentationStyle)
    }
    
    //Allow the promotion choices vc to be dismissed when user taps outside of the VC's bounds
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool{
        return true
    }
    
    //deselect the selected square if the user dismisses the promtion choices pop over
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        chessBoardViewController.deselectSelectedSquare()
    }
    
    //Ensure the promotion choices vc is always displayed as a popover
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle{return .none}
    
    //MARK: Handling Completion of Promotion Choice
    
    private func promotionCompletionHandler(chessPieceTypeToPromoteTo: ChessPieceType,endPosition:Position)
    {
        let startPosition = ModelViewTranslation.modelPosition(from:(lastSelectedSquare?.position)!)
        //reperform the the move but with the type of the chess piece to promote
        guard let (move,opponentInCheck,outcome) = performMove(from: startPosition, to: endPosition, chessPieceTypeToPromoteTo: chessPieceTypeToPromoteTo) else {return}
        updateBoardAfter(move:move, opponentInCheck:opponentInCheck,outCome:outcome)
    }
    
    func singleTapOccured(on tappedChessBoardSquare: ChessBoardSquareView){
        
        //verify if the position of the previously selected matches the tapped square
        if tappedChessBoardSquare == lastSelectedSquare{
            //if they match deselect the square
            chessBoardViewController.deselectSelectedSquare()
            
            //else verify whether or not another (necessarily different square was previously selcted
        }else if let lastSelectedSquare = self.lastSelectedSquare{
            
            //prepare old and new position parameters to call movePiece
            let oldPosition = ModelViewTranslation.modelPosition(from: lastSelectedSquare.position)
            let newPosition = ModelViewTranslation.modelPosition(from: tappedChessBoardSquare.position)
            
            //if that square is occupied by a piece of the same color
            //delect the previously selected square and
            //select the square that has just been tapped
            if  let colorOfPiece1 = chessGame.piece(at: oldPosition)?.color,
                let colorOfPiece2 = chessGame.piece(at: newPosition)?.color,
                colorOfPiece1 == colorOfPiece2{
                chessBoardViewController.deselectSelectedSquare()
                chessBoardViewController.select(square: tappedChessBoardSquare)
                return
            }
            
            //Attempt to perform the move and return if the move fails
            guard let (move,opponentInCheck,outcome) = performMove(from: oldPosition, to: newPosition) else {return}
            
            //update the board appropriately after the move and give user appropriate feedback
            updateBoardAfter(move:move, opponentInCheck:opponentInCheck,outCome:outcome)
            
        } else if tappedChessBoardSquare.isOccupied {
            //otherwise if no square was previously selected
            //and there is a piece on the tapped square, select the square
            //verify that the piece in the square is of the appropriate color,
            //i.e. that it is that color's turn to play
            let colorOfTappedPiece = tappedChessBoardSquare.chessPiece!.chessPieceIdentifier.color
            if colorOfTappedPiece.rawValue == chessGame.colorWhoseTurnItIs.rawValue{
                chessBoardViewController.select(square: tappedChessBoardSquare)
            }
        }
    }
    
    func doubleTapOccured() {
        //if a square is selected deselect
        if lastSelectedSquare != nil{
            chessBoardViewController.deselectSelectedSquare()
        }else {//otherwise undo the last move
            let lastMove = undoLastMove()
            //if a piece was put back remove it from the graveyard
            if let pieceResurrected = lastMove?.pieceCaptured{
                removeChessPieceFromGraveYard(chessPiece: pieceResurrected)
            }
        }
    }
    
    //MARK: - Performing and Undoing Move
    
    //MARK: Perform Move
    private func performMove(from oldPosition: Position,to newPosition: Position, chessPieceTypeToPromoteTo: ChessPieceType? = nil)->((Move, Bool, Outcome?)?){
        //ask the model to attempt the move and verify if it is legal in doing so
        //if the move is legal it is executed in the model
        guard let (move,opponentInCheck,outcome) = chessGame.movePiece(from: oldPosition, to: newPosition, typeOfPieceToPromoteTo: chessPieceTypeToPromoteTo) else{return nil}
        
        //Translate the model move into view move
        let viewMove = ModelViewTranslation.chessBoardViewMove(from: move)
        
        //move the piece in the ChessBoardView
        chessBoardViewController.perform(move: viewMove,animate:animate)
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
            chessBoardViewController.undo(move: lastViewMove, animate:animate)
            return lastMove
        }
        return nil
    }
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set up the chess timers
        setUpTimers()
        //Set yourself as the promotion delegate of the chessgame
        chessGame.promotionDelegate = self
        //place piece in initial positions
        placePiecesAtStartingPosition()
    }

   
    private func setUpTimers(){
        blackTimerViewController?.mode = .CountDown
        blackTimerViewController?.setInitialTime(to: initialTime)
        whiteTimerViewController?.mode = .CountDown
        whiteTimerViewController?.setInitialTime(to: initialTime)
    }
    
    
    //MARK: - Post Move Execution
    
    private func updateBoardAfter(move:Move, opponentInCheck:Bool,outCome:Outcome?){
        //deselect the previously selected square
        chessBoardViewController.deselectSelectedSquare()
        
        //if a piece was captured update the graveyardView so players can keep track of what pieces were captured
        if let pieceCaptured =  move.pieceCaptured{
            _ = addChessPieceToGraveYard(chessPiece: pieceCaptured)
        }
        
        //give the user visual feedback based on the outcome of the move
        //tells players:
        //1. when king is in check
        //2. check mate occurs
        //3. reach a draw
        giveUserFeedBackBased(on: outCome, opponentInCheck: opponentInCheck)
    }
    
    //MARK: - ChessGame Notifications
    
    var notificationsFrame:CGRect{
        let notificationSize = CGSize(width: 100, height: 30)
        return CGRect(center: chessBoardView.bounds.mid, size: notificationSize)
    }
    
    
    //MARK: User FeedBack
    
    private func giveUserFeedBackBased(on outcome: Outcome?, opponentInCheck:Bool){
        var notificationType:ChessNotification.NotificationType? = nil
        if let outcome = outcome{
            switch outcome {
            case Outcome.Win(let winingColor):
                notificationType = .Win(winingColor)
            case Outcome.Draw:
                notificationType = .Draw
            }
        } else if opponentInCheck == true {
            notificationType = .Check
        }
        guard notificationType != nil else {return}
        let chessNotification = ChessNotification(frame: notificationsFrame, type: notificationType!)
        self.chessBoardView.addSubview(chessNotification)
    }
    
    //MARK: - Navigation
    //MARK: Embed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == StoryBoard.BlackChessPieceGraveYardViewController){
            blackChessPieceGraveYardViewController = segue.destination as! BlackChessPieceGraveYardViewController
        }else if (segue.identifier == StoryBoard.WhiteChessPieceGraveYardViewController){
            whiteChessPieceGraveYardViewController = segue.destination as! WhiteChessPieceGraveYardViewController
        }else if (segue.identifier == StoryBoard.BlackTimerViewController && timersEnabled){
            blackTimerViewController = segue.destination as? BlackTimerViewController
        }else if (segue.identifier == StoryBoard.WhiteTimerViewController && timersEnabled){
            whiteTimerViewController = segue.destination as? WhiteTimerViewController
        }else if (segue.identifier == StoryBoard.ChessBoardViewController){
            chessBoardViewController = segue.destination as? ChessBoardViewController
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
    
    //MARK: - Initial Placement of Pieces in Game
    
    private func placePiecesAtStartingPosition(){
        chessBoardViewController.placePiecesAt(positions: initialChessPiecePositions)
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
