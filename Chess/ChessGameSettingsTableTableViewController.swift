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
        static let chessClock: ChessClock? = nil
        static let clockTime: Int = 5 * 60 // 5 minutes
    }
    
    struct Constants{
        static let noTakebacks = TakebackCount.Finite(0)
        static let maxTakeBacksSliderValue = 10
        static let minTakeBacksSliderValue = 1
    }
    
    //MARK: - Model
    
    var maxTakebackCount = Default.takebackCount
    var chessClock = Default.chessClock
    
    var chessGameSettings:ChessGameSettings{
        let chessGameSettings = ChessGameSettings(maxTakebacks: maxTakebackCount, chessClock: chessClock)
        return chessGameSettings
    }
    
    private var clockTimeString:String{
        //make sure chess clock is not nil
        guard let totalSeconds =  chessClock?.initialTime else {return "∞"}
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
        clockSwitch.isOn = chessGameSettings.chessClock != nil
        enableOrDisableClockTimeCellCell(if: clockSwitch.isOn)
        
        //set position of takebacks switch
        takebacksSwitch.isOn = chessGameSettings.maxTakebacks != TakebackCount.Finite(0)
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
    
    
    
    //MARK: - Enabling and Disabling cells
    
    private func enableOrDisableMaxTakebacksCell(if bool:Bool){
        switch (maxTakebackCount, bool) {
        case (.Finite(let count), true) where count == 0:
            maxTakebackCount = Default.takebackCount
        case (.Finite(let count),false) where count != 0:
            maxTakebackCount = Constants.noTakebacks
        case (.Infinite,false):
            maxTakebackCount = Constants.noTakebacks
        default:
            break

        }
        enableOrDisable(cell:maxTakeBacksCell, if:bool)
        maxTakeBacksLabel?.text = maxTakebackCount.description
    }
    
    private func enableOrDisableClockTimeCellCell(if bool:Bool){
        if chessClock == nil && bool{
            chessClock = ChessClock(with: Default.clockTime)
        }else if chessClock != nil && !bool{
            chessClock = nil
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
        //tell it the initial slider value
        maxTakebackVC.setMinMaxIntegerSliderValues(min: Constants.minTakeBacksSliderValue, max: Constants.maxTakeBacksSliderValue)
        if !maxTakebackVC.setInitialSliderValue(toTakebackCount: maxTakebackCount) {
            print("failed to set initial slider value")
        }
        
    }
    
    private func prepare(clockTimeVC:ClockTimeViewController){
        //tell it the initial slider value
        
    }
    
    private func prepare(chessGameVC: ChessGameViewController){
        //give chess game VC the game settings set by the user
        chessGameVC.gameSettings = chessGameSettings
    }
}


