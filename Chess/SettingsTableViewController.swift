//
//  SettingsTableViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-15.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    struct StoryBoard{
        static let MaxTakebacksSegue = "MaxTakebacks"
        static let ClockTime = "ClockTime"
        static let ChessBoardThemeSegue = "ChessBoardTheme"
    }
    
    //MARK: - Model
    var settings:ChessSettings = ChessSettings()
    
    
    //MARK: - View Controller Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

   //MARK: - Actions
    
    @IBAction func chessNotificationsSwitchValueChanged(_ sender: UISwitch) {
        settings.notificationsEnabled = sender.isOn
    }

    @IBAction func animationsSwitchValueChanged(_ sender: UISwitch) {
        settings.animationsEnable = sender.isOn
    }
    
    @IBAction func chessClockSwitchValueChanged(_ sender: UISwitch) {
        sender.isOn ? enable(cell: timeControlCell) : disable(cell: timeControlCell)

    }

    @IBAction func takeBacksSwitchValueChanged(_ sender: UISwitch) {
        sender.isOn ? enable(cell: maxTakeBacksCell) : disable(cell: maxTakeBacksCell)
    }

   
    //MARK: - Outlets

    @IBOutlet weak var timeControlCell: UITableViewCell!
    
    @IBOutlet weak var maxTakeBacksCell: UITableViewCell!

    

    //MARK: - Enabling and Disabling Cell
    
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
        }else if identifier == StoryBoard.ChessBoardThemeSegue{
            prepare(chessBoardThemeCollectionVC:(segue.destination.contentViewController as! ChessBoardThemeCollectionViewController))
        }
    }
    
    private func prepare(maxTakebackVC:MaxTakebackViewController){
        //tell it the initial slider value
        
    }

    private func prepare(clockTimeVC:ClockTimeViewController){
        //tell it the initial slider value

    }
    
    private func prepare(chessBoardThemeCollectionVC:ChessBoardThemeCollectionViewController){
        //select the appropriate chess theme to indicate
        //the theme that was chosen last
        chessBoardThemeCollectionVC.selectedTheme = settings.chessBoardTheme
    }
    
    


}
