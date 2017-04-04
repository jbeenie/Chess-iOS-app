//
//  SaveGameTableViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-30.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit
import CoreData


public struct ChessGameInfo{
    var chessGameID:NSManagedObjectID?
    var blackPlayer:String
    var whitePlayer:String
    var chessGame:ChessGame
    var chessClock:ChessClock?
    var whiteTakebacksRemaining:TakebackCount?
    var blackTakebacksRemaining:TakebackCount?
}

class SaveGameTableViewController: UITableViewController, UITextFieldDelegate {
    
    private struct Constants{
        static let maxPlayerStringLength = 15
        static let minPlayerStringLength = 1

    }
    
    //MARK: - Model
    var chessGameInfo:ChessGameInfo! = nil
    
    private var context: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.newBackgroundContext()
    
    //MARK: - Saving Game to Core Data
    
    private var gamePreviouslySaved:Bool{
        return chessGameInfo.chessGameID != nil
    }
    
    private func saveGame(){
        //ensure context is not nil
        guard let context = context else{return}
        //perform the saving block
        context.perform {
            guard let chessGameMO = ChessGameMO.chessGameWith(chessGameInfo: self.chessGameInfo, inManagedObjectContext: context) else {return}
            if self.gamePreviouslySaved{
                //update the game previously saved on the DB
                chessGameMO.updateWith(chessGameInfo: self.chessGameInfo, inManagedObjectContext: context)
            }
            //Commit changes to NSManagedObjectContext
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        }
    }
    
    //MARK: - Recording User Input
    
    private func updateChessGameInfo(){
        chessGameInfo.blackPlayer = blackPlayerTextField?.text ?? ""
        chessGameInfo.whitePlayer = whitePlayerTextField?.text ?? ""
    }
    
    //MARK: - Validate User Input
    
    private func validateChessGameInfo()->Bool{
        //Make sure String length is within the allowable range"
        let valid = chessGameInfo.blackPlayer.length >= Constants.minPlayerStringLength &&
                    chessGameInfo.blackPlayer.length <= Constants.maxPlayerStringLength &&
                    chessGameInfo.whitePlayer.length >= Constants.minPlayerStringLength &&
                    chessGameInfo.whitePlayer.length <= Constants.maxPlayerStringLength
        return valid
    }
    
    //MARK: -  Actions
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        updateChessGameInfo()
        guard validateChessGameInfo() else {
            //TODO: - Tell the user he needs to do something different
            print("Invalid Input")
            return
        }
        saveGame()
        self.navigationController?.popViewController(animated: true)
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
        updateChessGameInfo()
        textField.resignFirstResponder()
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


