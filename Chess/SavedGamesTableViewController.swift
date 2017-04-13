//
//  SavedGamesTableViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-30.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit
import CoreData

class SavedGamesTableViewController: FetchResultsTableViewController<ChessGameMO> {
    //MARK: - Constants
    private struct StoryBoard{
        static let cellID = "savedGame"
        static let ChessGameViewController = "ChessGameViewController"
    }
    
    private struct SortDescriptors{
        static let whitePlayer = NSSortDescriptor(key: "whitePlayer.name",ascending: true,
                                                  selector: #selector(NSString.localizedStandardCompare(_:)))
        static let blackPlayer = NSSortDescriptor(key: "blackPlayer.name",ascending: true,
                                                  selector: #selector(NSString.localizedStandardCompare(_:)))
        static let created = NSSortDescriptor(key: "created",ascending: true,
                                              selector: #selector(NSDate.compare(_:)))
    }
    
        
    //MARK: - Stored Properties
    
    //MARK: Configuring NSFetchedResultsController
    private var context: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.newBackgroundContext()
    
    private var predicate = NSPredicate(value: true)
    
    
    private lazy var fetchRequest:NSFetchRequest<ChessGameMO> = {
        let fetchRequest:NSFetchRequest<ChessGameMO> = ChessGameMO.fetchRequest()
        fetchRequest.predicate = self.predicate
        fetchRequest.sortDescriptors = [SortDescriptors.whitePlayer,SortDescriptors.blackPlayer,SortDescriptors.created]

        return fetchRequest
    }()
    
    private var cacheName:String? = "gameCache"
    private var sectionNameKeyPath:String? = nil
    
    //MARK: Formatting Date and Time
    
    private var dateFormatter:DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd/MM/yyyy"

        return dateFormatter
    }
    
    private var timeFormatter:DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    //MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //always show navigation bar
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.hidesBarsOnTap = false
        navigationController?.setNavigationBarHidden(false, animated: false)

        //set the fetchedresultsController
        guard let context = context else {print("context is nil!");return}
        fetchedResultsController = NSFetchedResultsController<ChessGameMO>(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: sectionNameKeyPath,
            cacheName: cacheName)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryBoard.cellID, for: indexPath)
        
        guard let frc = fetchedResultsController else { return cell}
        guard let savedGameCell = cell as? SavedGameCell else {return cell}
        
        let chessGameMO = frc.object(at: indexPath)
        guard   let whitePlayer:String = chessGameMO.whitePlayer?.name,
                let blackPlayer:String = chessGameMO.blackPlayer?.name,
                let created:Date = chessGameMO.created as Date?
        else {return cell}
        
        // Configure the cell with data from the ChessGame managed object.
        savedGameCell.gameNumberLabel.text = "Game1"
        savedGameCell.playersLabel.text = "\(whitePlayer) vs. \(blackPlayer)"
        savedGameCell.dateLabel.text = dateFormatter.string(from: created)
        savedGameCell.timeLabel.text = timeFormatter.string(from: created)
        
        return savedGameCell;
    }
    //"2017-03-15"
    //"9:45 AM"

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == StoryBoard.ChessGameViewController){
            let chessGameViewController = segue.destination as! ChessGameViewController
            guard let selectedIndexPath = self.tableView.indexPathForSelectedRow else{
                print("No Cell Selected!")
                return
            }
            //Get the ChessGameMO using the selected index path
            guard let chessGameSnapShot = fetchedResultsController?.object(at: selectedIndexPath).snapShot else{
                print("chess Snap Shot is nil!")
                return
            }
            
            //use the ChessGameMO data to prepare the chessGameVC
            
            //extract the data from the ChessGameMO
            guard let chessGame = Archiver.unArchive(data: chessGameSnapShot.gameSnapShot as Data?) as? ChessGame,
            let chessClock = Archiver.unArchive(data: chessGameSnapShot.clockSnapShot as Data?) as? ChessClock?,
            let whiteTakebacksRemaining = TakebackCount(integer: Int(chessGameSnapShot.whiteTakebacksRemaining)),
            let blackTakebacksRemaining = TakebackCount(integer: Int(chessGameSnapShot.blackTakebacksRemaining))
            else{
                print("Could not extract data from chessGameSnapShot")
                return
            }
            
            //prepare the chessGameVC with the data
            chessGameViewController.snapShot = ChessGameSnapShot(
                gameSnapShot: chessGame,
                clockSnapShot: chessClock,
                whiteTakebacksRemaining: whiteTakebacksRemaining,
                blackTakebacksRemaining: blackTakebacksRemaining)
            chessGameViewController.gameWasLoaded = true
            chessGameViewController.gameSettings = ChessGameSettings.loadGameSettings()
            
        }
    }
    

}
