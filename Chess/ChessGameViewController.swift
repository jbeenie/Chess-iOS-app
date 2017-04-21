//
//  ChessGameViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-13.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit
import CoreData

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
        static let SaveGameTableViewController = "SaveGameTableViewController"
        static let BackFromSaveGameViewController = "BackFromSaveGameViewController"
        
    }
    
    struct Ratios{
        static let popOverWidthToChessBoardWidth:CGFloat = 0.5
        static let popOverWidthToPopOverHeight:CGFloat = 4
    }
    
    struct Constants{
        static let blackPerspectiveRotationAngle = CGFloat.pi
    }
    
    //MARK: - Properties
    
    //MARK: 2 Setup Modes
    
    //MARK: Mode 1 - New Game created - setup using game settings
    var gameSettings:ChessGameSettings! = nil{
        //Prevent original Game Settings from being over written
        willSet{self.gameSettings = self.gameSettings ?? newValue}
    }

    
    //MARK: Mode 2 - Game was Loaded - setup using game snapshot
    var gameInDB = false
    var chessGameID:NSManagedObjectID? = nil
    
    lazy var snapShot:ChessGameSnapShot = ChessGameSnapShot(
                                    gameSnapShot: self.chessGame,
                                    clockSnapShot: self.chessClock,
                                    whiteTakebacksRemaining: self.whiteTakebacksViewController.takebackCount,
                                    blackTakebacksRemaining: self.blackTakebacksViewController.takebackCount)
    
    //MARK: SubViews
    //MARK: Board
    private var chessBoardView:ChessBoardView!{
        return chessBoardViewController.chessBoardView
    }
    private var lastSelectedSquare: ChessBoardSquareView?{
        return chessBoardViewController.lastSelectedSquare
    }
    
    private var currentNotification:ChessNotification? = nil
    
    private var blackPlayerViews:[UIView]{
        var blackPlayerViews = [UIView]()
        if let blackTimerView = blackTimerViewController?.view{
            blackPlayerViews.append(blackTimerView)
        }
        return blackPlayerViews + [blackTakebacksViewController.view,blackChessPieceGraveYardViewController.view]
    }
    
    
    //MARK: - Model
    
    //MARK: ManagedObjectContext
    private lazy var context: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.newBackgroundContext()
    
    //MARK: Chess game
    var chessGame: ChessGame = {
        let chessGame = ChessGame()
        chessGame.PlacePiecesInInitialPositions()
        return chessGame
    }()
    
    
    //MARK: Chess Clock
    lazy var chessClock:ChessClock? = {
        guard self.gameSettings.clockEnabled else {return nil}
        return ChessClock(with: self.gameSettings.clockTime)
    }()
    
    //MARK: Orientation Managers
    private lazy var chessPieceVOM:ViewOrientationManager = ViewOrientationManager(rotationAngle: Constants.blackPerspectiveRotationAngle, views: self.chessBoardViewController.pieces, animate: self.gameSettings.animationsEnabled)
    
    private lazy var blackPlayerVOM:ViewOrientationManager = ViewOrientationManager(rotationAngle: Constants.blackPerspectiveRotationAngle, views: self.blackPlayerViews, animate: false)
    
    private lazy var notificationsVOM:ViewOrientationManager = ViewOrientationManager(rotationAngle: Constants.blackPerspectiveRotationAngle, animate: false)
    
    //Computed Properties

    //MARK: Game state
    private var gameEnded:Bool{
        return chessGame.ended || (chessClock?.timeIsUp ?? false)
    }
    
    private var gameIsPaused:Bool{
        guard let chessClock = chessClock else {return false}
        return chessClock.paused
    }
    
    
    //MARK: Notifications
    var resignActiveObserver: NSObjectProtocol? = nil
    
    private lazy var prepareForInactive:(Notification) -> Void = { (note) in
        //pause the clock if the app becomes inactive
        self.chessClock?.pause()
    }
    
    private var notificationCenter:NotificationCenter{
        return NotificationCenter.default
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
        let viewColor = ModelViewTranslation.chessPieceColorMap[ color]
        let viewPosition = ModelViewTranslation.positionMap[position]
        
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
        let startPosition = ModelViewTranslation.positionMap[(lastSelectedSquare?.position)!]
        //reperform the the move but with the type of the chess piece to promote
        _ = performMove(from: startPosition, to: endPosition, chessPieceTypeToPromoteTo: chessPieceTypeToPromoteTo)
    }
    
    //MARK: ChessBoardViewControllerDelegate Conformance
    
    func tapOccured(on tappedChessBoardSquare: ChessBoardSquareView){
        //ensure clock is running before allowing a player to perform a move
        guard !gameIsPaused else {return}
    
        
        //ensure game is not ended
        guard !gameEnded else {return}
        
        //verify if the position of the previously selected matches the tapped square
        if tappedChessBoardSquare == lastSelectedSquare{
            //if they match deselect the square
            chessBoardViewController.deselectSelectedSquare()
            
            //else verify whether or not another (necessarily different square was previously selcted
        }else if let lastSelectedSquare = self.lastSelectedSquare{
            
            //prepare old and new position parameters to call movePiece
            let oldPosition = ModelViewTranslation.positionMap[lastSelectedSquare.position]
            let newPosition = ModelViewTranslation.positionMap[tappedChessBoardSquare.position]
            
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
    
    func twoTouchTapOccured() {

        //ensure clock is running before allowing a player to undo a move
        guard !gameIsPaused else {return}
        //if a square is selected deselect it
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
    
    func threeTouchTapOccured() {
        //if the game is not timed three touch taps do nothing
        guard let chessClock = chessClock else{return}
        //if the clock is paused then unpause it
        //if the clock is unpauses then pause it
        chessClock.pauseUnPause()
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
            
            //toggle orientation of chess pieces after move is undone
            let toggleOrientation = { self.chessPieceVOM.toggleOrientation() }
            
            //remove the current notification if necessary
            //then undo the last move on the chessBoardView
            removeNotification {self.chessBoardViewController.undo(move: lastViewMove, animate:self.gameSettings.animationsEnabled, completion: toggleOrientation)}
            
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
        //setup delegate of chessBoardViewController
        chessBoardViewController.delegate = self
        
        // New/Loaded Game dependent setup
        if gameInDB{
            setupLoadedGame()
        }else{
            setupNewGame()
        }
        
        //Set up delegation
        //promotion delegate of the chessgame
        chessGame.promotionDelegate = self
        
        //delegate of chessClock
        chessClock?.delegate = self
        
        //Hookup the chessClock to the timer view controllers
        whiteTimerViewController?.timer = chessClock?.whiteTimer
        blackTimerViewController?.timer = chessClock?.blackTimer
        
        //Orient the appropriate views in blacks perspective
        blackPlayerVOM.rotateViews()
        
        //Register observer with Notification Center to be informed when app becomes inactive
        resignActiveObserver = notificationCenter.addObserver(
            forName: NSNotification.Name.UIApplicationWillResignActive,
            object: nil,
            queue: OperationQueue.main,// queue to run block on
            using: prepareForInactive)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //alow navigation bar to shown on swipe and tap
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //pause ChessClock
        chessClock?.pause()
    }
        
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupLoadedGame(){
        //place pieces
        chessGame = snapShot.gameSnapShot
        chessClock = snapShot.clockSnapShot
        let chessPieceViewPositions = ModelViewTranslation.viewChessPiecePositions(from: chessGame.piecePositions)
        chessBoardViewController.placePiecesAt(positions: chessPieceViewPositions)
        //set remaining takebacks
        whiteTakebacksViewController.takebackCount =  snapShot.whiteTakebacksRemaining
        blackTakebacksViewController.takebackCount = snapShot.blackTakebacksRemaining
        //load graveYard
        let (whitePiecesCaptured,blackPiecesCaptured) = chessGame.piecesCaptured
        _ = whiteChessPieceGraveYardViewController.add(chessPieces: blackPiecesCaptured)
        _ = blackChessPieceGraveYardViewController.add(chessPieces: whitePiecesCaptured)
        //Rotate pieces if necessary
        if chessGame.colorWhoseTurnItIs == .Black {
            chessPieceVOM.toggleOrientation()
        }
    }
    
    private func setupNewGame(){
        //place pieces in initial positions
        placePiecesAtStartingPosition()
        
        //set up takebackviewcontroller models
        whiteTakebacksViewController.takebackCount =  gameSettings.effectiveMaxTakebacksCount
        blackTakebacksViewController.takebackCount = gameSettings.effectiveMaxTakebacksCount
    }
    
    
    //MARK: - DeInitializer
    deinit {
        if let resignActiveObserver = resignActiveObserver{
        notificationCenter.removeObserver(
            resignActiveObserver,
            name: NSNotification.Name.UIApplicationWillResignActive,
            object: nil)
        }
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
        
        //update list of views in the chess piece VOM's
        chessPieceVOM.views = chessBoardView.pieces
        
        //if a piece was captured update the graveyardView so players can keep track of what pieces were captured
        if let pieceCaptured =  move.pieceCaptured{
            _ = addChessPieceToGraveYard(chessPiece: pieceCaptured)
        }
        
        //post notification after chess pieces are rotated
        let postNotification = {
            if(self.gameSettings.notificationsEnabled){
                self.giveUserFeedBackBased(on: outCome)
            }
        }
        
        //toggle orientation of chess pieces
        chessPieceVOM.toggleOrientation(completion: postNotification)
    }
    
    //MARK: - ChessGame Notifications
    
    private func post(notification:ChessNotification, temporarily:Bool=true){
        //add the notifiation to the chess board view
        self.chessBoardView.addSubview(notification)
        
        //rotatate notification if necessary
        notificationsVOM.views.append(notification)
        notificationsVOM.rotationAngle = (chessGame.colorWhoseTurnItIs == .White) ? 0 : Constants.blackPerspectiveRotationAngle
        notificationsVOM.rotateViews()
        notificationsVOM.views.removeLast()
        
        //prepare notification for posting
        currentNotification = notification
        notification.frame = chessBoardView.bounds
        notification.centerAndResizeLabel()
        
        //animate the posting of the notification
        notification.animatePosting()
    }
    
    private func removeNotification(completionHandler:(()->Void)? = nil){
        if let notification = currentNotification{
            notification.animateRemoval(completionHanlder: completionHandler)
        }else{completionHandler?()}
    }
    
    
    //MARK: - Navigation
    
    @IBAction func backToGameViewController(sender: UIStoryboardSegue) {
        if sender.identifier == StoryBoard.BackFromSaveGameViewController{
            gameInDB = true
            chessGameID = (sender.source as? SaveGameTableViewController)?.gameID
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Embedded Segues
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
            
        //Actual Segues
        }else if (segue.identifier == StoryBoard.SaveGameTableViewController){
            let saveGameTableViewController = segue.destination as? SaveGameTableViewController
            //Give the saveGameTableVC the snapshot of the game
            saveGameTableViewController?.snapShot = self.snapShot
        }
    }
    
    
    @IBAction func saveGame(_ sender: UIBarButtonItem) {
        //pause chess clock
        chessClock?.pause()
        //update snapsot of game
        snapShot.update(gameSnapShot: chessGame,
                        clockSnapShot: chessClock,
                        whiteTakebacksRemaining: whiteTakebacksViewController.takebackCount,
                        blackTakebacksRemaining: blackTakebacksViewController.takebackCount)
        if  gameInDB {
            let alert = SaveGameAlert.createWith(save: save,saveAs: saveAsNewGame)
            alert.modalPresentationStyle = .popover
            let ppc = alert.popoverPresentationController
            ppc?.barButtonItem = sender
            self.present(alert, animated: true, completion: nil)
        }else{
            saveAsNewGame()
        }
    }
    
    //MARK: - Saving Games
    
    private func saveAsNewGame(action: UIAlertAction?=nil){
        performSegue(withIdentifier: StoryBoard.SaveGameTableViewController, sender: nil)
    }
    
    //Update the chess game in the database with the new game state
    private func save(action:UIAlertAction){
        guard let context = context, let chessGameID = chessGameID
        else{
            print("Error getting context or chessGameID")
            print("context: \(String(describing: self.context)), chessGameID: \(String(describing: self.chessGameID))")
            return
        }
        ChessGameMO.updateChessGameHaving(id: chessGameID,
                                          inManagedObjectContext: context,
                                          with: snapShot) {
            //completion closure
            CoreDataUtilities.save(context: context)
            self.chessGameID = $0.objectID
            print("Succeeded in updating chessGame")
        }
        
        
        //Commit changes to NSManagedObjectContext
        do {
            try self.context?.save()
        } catch let error {
            print("Core Data Error: \(error)")
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
        let initialChessPieceViewPositions = ModelViewTranslation.viewChessPiecePositions(from: chessGame.initialPiecePositions)
        chessBoardViewController.placePiecesAt(positions: initialChessPieceViewPositions)
    }
}
