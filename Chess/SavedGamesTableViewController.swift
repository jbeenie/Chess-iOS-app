//
//  SavedGamesTableViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-30.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class SavedGamesTableViewController: UITableViewController {

    struct StoryBoard{
        static let cellID = "savedGame"
        static let ChessGameViewController = "ChessGameViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryBoard.cellID, for: indexPath)
        if let savedGameCell = cell as? SavedGameCell{
            savedGameCell.gameNumberLabel.text = "Game11"
            savedGameCell.playersLabel.text = "Beenie vs. Maxime"
            savedGameCell.dateLabel.text = "2017-03-15"
            savedGameCell.timeLabel.text = "9:45 AM"
        }
        

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == StoryBoard.ChessGameViewController){
            let chessGameViewController = segue.destination as! ChessGameViewController
            let _ = sender as! SavedGameCell
            
            //TODO: Remove this after Testing
            //************************************
            let defaults = UserDefaults.standard
            let chessGame = Archiver.unArchive(data: defaults.object(forKey: "ChessGameTemp") as? Data) as? ChessGame
            let chessClock = Archiver.unArchive(data: defaults.object(forKey: "ChessClockTemp") as? Data) as? ChessClock
            let whiteTakebacksRemaining =  TakebackCount(integer: defaults.integer(forKey: "WTBR"))
            let blackTakebacksRemaining = TakebackCount(integer: defaults.integer(forKey: "BTBR"))
            
            chessGameViewController.snapShot = ChessGameSnapShot(
                gameSnapShot: chessGame!,
                clockSnapShot: chessClock,
                whiteTakebacksRemaining: whiteTakebacksRemaining!,
                blackTakebacksRemaining: blackTakebacksRemaining!)
            chessGameViewController.gameWasLoaded = true
            chessGameViewController.gameSettings = ChessGameSettings.loadGameSettings()
            print(chessGameViewController.snapShot.gameSnapShot.description)
            //************************************
        }
    }
    

}
