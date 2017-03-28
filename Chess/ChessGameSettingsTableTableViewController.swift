//
//  ChessGameSettingsTableTableViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-23.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class ChessGameSettingsTableTableViewController: UITableViewController {
    //MARK: - Constants
    struct StoryBoard{
        static let MaxTakebacksSegue = "MaxTakebacks"
        static let ClockTime = "ClockTime"
        static let ChessGame = "ChessGame"
    }
    
    struct Default{
        static let takebackCount = TakebackCount.Infinite
        static let clockTime: Int = 5 * 60 // 5 minutes
    }
    
    struct Constants{
        static let noTakebacks = TakebackCount.Finite(0)
        static let shouldHighlightRowAt:[IndexPath:Bool] = [
            IndexPath(row: 0, section: 0):false,
            IndexPath(row: 1, section: 0):true,
            IndexPath(row: 0, section: 1):false,
            IndexPath(row: 1, section: 1):true
        ]
    }
    
    //MARK: - Model
    
    
    var gameSettings:ChessGameSettings = ChessGameSettings.loadGameSettings()
    
    private var clockTimeString:String{
        //make sure chess clock is not nil
        guard let totalSeconds =  gameSettings.clockTime else {return "∞"}
        //if its not nil use its initial time property to create the clock time string
        var timeFormatter = TimeFormatter()
        timeFormatter.totalSeconds = totalSeconds
        return timeFormatter.hoursMinutesString
    }
    
    
    //MARK: - Outlets
    //Table View Cells
    @IBOutlet weak var clockTimeCell: UITableViewCell!
    @IBOutlet weak var maxTakeBacksCell: UITableViewCell!
    //Switches
    @IBOutlet weak var clockSwitch: UISwitch!
    @IBOutlet weak var takebacksSwitch: UISwitch!
    //Labels
    @IBOutlet weak var clockTimeLabel: UILabel!
    @IBOutlet weak var maxTakeBacksLabel: UILabel!
    //MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.clearsSelectionOnViewWillAppear = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update()
    }
    
    //MARK: update state of the VC with the current game settings when it appears
    private func update(){
        //update clock related
        clockSwitch.isOn = gameSettings.clockTime != nil
        enableOrDisableClockTimeCellCell(if: clockSwitch.isOn)
        
        //set position of takebacks switch
        takebacksSwitch.isOn = gameSettings.maxTakebacks != TakebackCount.Finite(0)
        enableOrDisableMaxTakebacksCell(if:takebacksSwitch.isOn)
    }
    
    //MARK: - Actions
    
    @IBAction func chessClockSwitchValueChanged(_ sender: UISwitch) {
        enableOrDisableClockTimeCellCell(if:sender.isOn)
    }
    
    @IBAction func takeBacksSwitchValueChanged(_ sender: UISwitch) {
        enableOrDisableMaxTakebacksCell(if:sender.isOn)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: -  Action Handlers
    
    //MARK: Enabling and Disabling cells
    
    private func enableOrDisableMaxTakebacksCell(if bool:Bool){
        switch (gameSettings.maxTakebacks, bool) {
        case (.Finite(let count), true) where count == 0:
            gameSettings.maxTakebacks = Default.takebackCount
        case (.Finite(let count),false) where count != 0:
            gameSettings.maxTakebacks = Constants.noTakebacks
        case (.Infinite,false):
            gameSettings.maxTakebacks = Constants.noTakebacks
        default:
            break

        }
        enableOrDisable(cell:maxTakeBacksCell, if:bool)
        maxTakeBacksLabel?.text = gameSettings.maxTakebacks.description
    }
    
    private func enableOrDisableClockTimeCellCell(if bool:Bool){
        if gameSettings.clockTime == nil && bool{
            gameSettings.clockTime =  Default.clockTime
        }else if gameSettings.clockTime != nil && !bool{
            gameSettings.clockTime = nil
        }
        enableOrDisable(cell:clockTimeCell, if:bool)
        clockTimeLabel?.text = clockTimeString
    }

    
    private func enableOrDisable(cell:UITableViewCell, if bool :Bool){
        bool ? enable(cell: cell) : disable(cell: cell)
    }
    
    private func disable(cell:UITableViewCell){
        cell.isUserInteractionEnabled = false
        cell.textLabel!.isEnabled = false
        cell.detailTextLabel!.isEnabled = false
    }
    
    private func enable(cell:UITableViewCell){
        cell.isUserInteractionEnabled = true
        cell.textLabel!.isEnabled = true
        cell.detailTextLabel!.isEnabled = true
    }
    
    //MARK: - Specify which cells are selectable
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return Constants.shouldHighlightRowAt[indexPath]!
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        if identifier == StoryBoard.MaxTakebacksSegue{
            prepare(maxTakebackVC:(segue.destination.contentViewController as! MaxTakebackViewController))
        }else if identifier == StoryBoard.ClockTime{
            prepare(clockTimeVC:(segue.destination.contentViewController as! ClockTimeViewController))
        }else if identifier == StoryBoard.ChessGame{
            prepare(chessGameVC: (segue.destination.contentViewController as! ChessGameViewController))
        }
    }
    
    private func prepare(maxTakebackVC:MaxTakebackViewController){
        //tell it the initial take back count to display
        maxTakebackVC.takebacks = gameSettings.maxTakebacks
    }
    
    private func prepare(clockTimeVC:ClockTimeViewController){
        //tell it the initial clock time value to display
        clockTimeVC.clockTime = gameSettings.clockTime!
    }
    
    private func prepare(chessGameVC: ChessGameViewController){
        //give chess game VC the game settings set by the user
        chessGameVC.gameSettings = gameSettings
        //save the chosen game settings
        gameSettings.save()
    }
    
}


