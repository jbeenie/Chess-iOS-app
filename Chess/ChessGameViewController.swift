//
//  ChessGameViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-13.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class ChessGameViewController: UIViewController,PromotionDelegate,UIPopoverPresentationControllerDelegate,ChessBoardViewControllerDelegate,ChessClockDelegate{

    struct StoryBoard{
        static let PromotionChoicesVCID = "PromotionPopOver"
        static let BlackChessPieceGraveYardViewController = "BlackChessPieceGraveYardViewController"
        static let WhiteChessPieceGraveYardViewController = "WhiteChessPieceGraveYardViewController"
        static let BlackTimerViewController = "BlackTimerViewController"
        static let WhiteTimerViewController = "WhiteTimerViewController"
        static let WhiteTakebacksViewController = "WhiteTakebacksViewController"
        static let BlackTakebacksViewController = "BlackTakebacksViewController"
        static let ChessBoardViewController = "ChessBoardViewController"
        
    }
    
    struct Ratios{
        static let popOverWidthToChessBoardWidth:CGFloat = 0.5
        static let popOverWidthToPopOverHeight:CGFloat = 4
    }
    
    //MARK: - Properties

//    let initialTimeOnClock:Int = 120 //seconds
//    let animate = true
    
    
    //MARK: SubViews
    //MARK: Board
    private var chessBoardView:ChessBoardView!{
        return chessBoardViewController.chessBoardView
    }
    private var lastSelectedSquare: ChessBoardSquareView?{
        return chessBoardViewController.lastSelectedSquare
    }
    private var currentNotification:ChessNotification? = nil
    
    
    //MARK: - Model
    //MARK: Chess game
    let chessGame: ChessGame = {
        let chessGame = ChessGame()
        chessGame.PlacePiecesInInitialPositions()
        return chessGame
    }()
    
    //MARK: Game settings
    var gameSettings:ChessGameSettings! = nil{
        //Prevent original Game Settings from being over written
        willSet{self.gameSettings = self.gameSettings ?? newValue}
    }
    
    //MARK: Chess Clock
    lazy var chessClock:ChessClock? = self.gameSettings.chessClock
    
    //Computed Properties

    //MARK: Determining whether game is Ended
    private var gameEnded:Bool{
        return chessGame.ended || (chessClock?.timeIsUp ?? false)
    }
    
    //MARK: - SubViewControllers
    //MARK: GRAVEYARDS
    private var blackChessPieceGraveYardViewController: BlackChessPieceGraveYardViewController!
    private var whiteChessPieceGraveYardViewController: WhiteChessPieceGraveYardViewController!
    //MARK: TIMERS
    private var whiteTimerViewController:WhiteTimerViewController?
    private var blackTimerViewController:BlackTimerViewController?
    //MARK: TakebackCounters
    private var whiteTakebacksViewController: WhiteTakebacksViewController!
    private var blackTakebacksViewController: BlackTakebacksViewController!
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
        _ = performMove(from: startPosition, to: endPosition, chessPieceTypeToPromoteTo: chessPieceTypeToPromoteTo)
    }
    
    //MARK: ChessBoardViewControllerDelegate Conformance
    
    func singleTapOccured(on tappedChessBoardSquare: ChessBoardSquareView){
        //ensure timers are started before allowing players to perform moves if timers are enable
        if let chessClock = chessClock{
            guard chessClock.clockStarted else {return}
        }
        
        //ensure game is not ended
        guard !gameEnded else {return}
        
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
            _ = performMove(from: oldPosition, to: newPosition)
            
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
        if let chessClock = chessClock, !chessClock.clockStarted{
            chessClock.start()//start whites timer
            return
        }
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
    
    var shouldAnimate: Bool{
        return gameSettings.animationsEnabled
    }
    
    //MARK: - Performing and Undoing Move
    
    //MARK: Perform Move
    private func performMove(from oldPosition: Position,to newPosition: Position, chessPieceTypeToPromoteTo: ChessPieceType? = nil)->((Move, Outcome?)?){
        //ask the model to attempt the move and verify if it is legal in doing so
        //if the move is legal it is executed in the model
        guard let (move,outcome) = chessGame.movePiece(from: oldPosition, to: newPosition, typeOfPieceToPromoteTo: chessPieceTypeToPromoteTo) else{return nil}
        
        //deselect the last selected square
        chessBoardViewController.deselectSelectedSquare()
        
        //Translate the model move into view move
        let viewMove = ModelViewTranslation.chessBoardViewMove(from: move)
        
        
        //Toggle timers
        chessClock?.moveOccured()
        
        //update the board appropriately after the move and give user appropriate feedback
        //if move is successful
        let moveCompletionHandler = { self.updateGameAfter(move: move, outCome: outcome) }
        
        //move the piece in the ChessBoardView
        chessBoardViewController.perform(move: viewMove,animate:gameSettings.animationsEnabled,moveCompletionHandler:moveCompletionHandler)
        
        //return the appropriate information
        return (move,outcome)
    }
    
    //MARK: Undo Move
    private func undoLastMove()->Move?{
        //get take back count controller of player taking back move
        let takebacksViewController = (chessGame.colorWhoseTurnItIs.opposite() == .White) ? whiteTakebacksViewController : blackTakebacksViewController
        
        //undo move iff player has remaining takebacks
        guard !takebacksViewController.takebackCount.isZero else {
            return nil
        }
        
        //undo the last move if any
        if let lastMove = chessGame.undoLastMove(){
            //translate move to view move
            let lastViewMove = ModelViewTranslation.chessBoardViewMove(from: lastMove)
            //remove the current notification if necessary
            //then undo the last move on the chessBoardView
            removeNotification {self.chessBoardViewController.undo(move: lastViewMove, animate:self.gameSettings.animationsEnabled)}
            
            //Roll back the clock
            chessClock?.moveUndone()
            
            //decrement the takebackcount
            takebacksViewController.takebackCount.decrement()
            return lastMove
        }
        //Reset the clock completely
        chessClock?.reset()
        return nil
    }
    
    //MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //alow navigation bar to shown on swipe
        navigationController?.hidesBarsOnSwipe = true
        
        //Set up delegation
        //promotion delegate of the chessgame
        chessGame.promotionDelegate = self
        //delegate of chessBoardViewController
        chessBoardViewController.delegate = self
        //delegate of chessClock
        chessClock?.delegate = self
        
        //set up takebackviewcontroller models
        whiteTakebacksViewController.takebackCount = gameSettings.maxTakebacks
        blackTakebacksViewController.takebackCount = gameSettings.maxTakebacks
        
        //place piece in initial positions
        placePiecesAtStartingPosition()
        
        //Hookup the chessClock to the timer view controllers
        whiteTimerViewController?.timer = chessClock?.whiteTimer
        blackTimerViewController?.timer = chessClock?.blackTimer
    }


    
    //MARK: - Conforming to ChessClock Delegate
    func timerUp(for color: ChessPieceColor) {
        let notification = ChessNotificationCreator.createChessNotification(type: Outcome.Win(color.opposite(), .TimerUp))
        post(notification: notification)
    }
    
    
    //MARK: - User FeedBack
    
    //give the user visual feedback based on the outcome of the move
    //tells players:
    //1. when king is in check
    //2. check mate occurs
    //3. reach a draw
    private func giveUserFeedBackBased(on outcome: Outcome?){
        guard outcome != nil else {return}
        let notification = ChessNotificationCreator.createChessNotification(type: outcome!)
        post(notification: notification)
    }
    
    //MARK: - Post Move Execution
    
    private func updateGameAfter(move:Move,outCome:Outcome?){
        
        //if a piece was captured update the graveyardView so players can keep track of what pieces were captured
        if let pieceCaptured =  move.pieceCaptured{
            _ = addChessPieceToGraveYard(chessPiece: pieceCaptured)
        }
        if(gameSettings.notificationsEnabled){giveUserFeedBackBased(on: outCome)}
    }
    
    //MARK: - ChessGame Notifications
    
    private func post(notification:ChessNotification, temporarily:Bool=true){
        self.chessBoardView.addSubview(notification)
        currentNotification = notification
        notification.frame = chessBoardView.bounds
        notification.centerAndResizeLabel()
        notification.animatePosting()
    }
    
    private func removeNotification(completionHandler:(()->Void)? = nil){
        if let notification = currentNotification{
            notification.animateRemoval(completionHanlder: completionHandler)
        }else{completionHandler?()}
    }
    
    
    //MARK: - Navigation
    //MARK: Embed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == StoryBoard.BlackChessPieceGraveYardViewController){
            blackChessPieceGraveYardViewController = segue.destination as! BlackChessPieceGraveYardViewController
        }else if (segue.identifier == StoryBoard.WhiteChessPieceGraveYardViewController){
            whiteChessPieceGraveYardViewController = segue.destination as! WhiteChessPieceGraveYardViewController
        }else if (segue.identifier == StoryBoard.BlackTimerViewController){
            blackTimerViewController = segue.destination as? BlackTimerViewController
        }else if (segue.identifier == StoryBoard.WhiteTimerViewController){
            whiteTimerViewController = segue.destination as? WhiteTimerViewController
        }else if(segue.identifier == StoryBoard.WhiteTakebacksViewController){
            whiteTakebacksViewController = segue.destination as? WhiteTakebacksViewController
        }else if(segue.identifier == StoryBoard.BlackTakebacksViewController){
            blackTakebacksViewController = segue.destination as? BlackTakebacksViewController
        }else if (segue.identifier == StoryBoard.ChessBoardViewController){
            chessBoardViewController = segue.destination as? ChessBoardViewController
            //Set the colors of the squares using the chessboard theme chosen
            chessBoardViewController.chessBoardTheme = gameSettings?.chessBoardTheme
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
