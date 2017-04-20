//
//  SaveGameTableViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-30.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit
import CoreData


class SaveGameTableViewController: UITableViewController, UITextFieldDelegate {

    private struct StoryBoard{
        static let BackFromSaveGameViewController = "BackFromSaveGameViewController"
    }
    
    //MARK: - Model
    var playerNames:PlayerNames = PlayerNames(white:"",black:"")
    var snapShot:ChessGameSnapShot! = nil
    var gameID:NSManagedObjectID? = nil
    
    private lazy var context: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.newBackgroundContext()
    
    
    
    //MARK: - Computed Properties
    
    private var chessGameInfo:ChessGameInfo{
        return ChessGameInfo(playerNames: playerNames,
                             snapShot: snapShot)
    }
    
    //MARK: - Saving Game to Core Data
    private func saveNewGame(){
        //ensure context is not nil
        guard let context = context else{return}
        //create new ChessGameMO in NSManagedObjectContext and save it
        ChessGameMO.createChessGameWith(chessGameInfo: self.chessGameInfo,
                                        inManagedObjectContext: context,
                                        completion: {
                                            CoreDataUtilities.save(context: context)//save changes
                                            self.gameID = $0?.objectID})//Register gameID
    }
    
    //MARK: - Recording User Input
    
    private func updatePlayerNames(){
        //FIXME: Crash When pressing return key on keyboard
        playerNames = PlayerNames(white: whitePlayerTextField?.text ?? "",
                                  black: blackPlayerTextField?.text ?? "")
    }
    
    //MARK: -  Actions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        updatePlayerNames()
        guard playerNames.areValid else {
            //TODO: - Tell the user he needs to do something different
            print("Invalid Input. Do something different.")
            return
        }
        saveNewGame()
        performSegue(withIdentifier: StoryBoard.BackFromSaveGameViewController, sender: nil)
    }
    //MARK: - Outlets
    
    @IBOutlet weak var whitePlayerTextField: UITextField!
    @IBOutlet weak var blackPlayerTextField: UITextField!
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        whitePlayerTextField.delegate = self
        blackPlayerTextField.delegate = self
        self.tableView.allowsSelection = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //make the keyboard show up for the user to input the white player string
        whitePlayerTextField.becomeFirstResponder()
    }
    
    

    //MARK: - UITextField Delegate
    
    //Hide keyboard when user presses return button on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updatePlayerNames()
        textField.resignFirstResponder()
        return true
    }


}


