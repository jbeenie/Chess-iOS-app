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
    
    private var chessBoardThemeTexts:[ChessBoardTheme:String]{
        return [ChessBoardThemes.GreenWhite:"Green/White",
            ChessBoardThemes.BrownYellow:"Brown/Yellow",
            ChessBoardThemes.GrayWhite:"Gray/White"]
    }
    
    
    //MARK: - Model
    //Grabs the settings from the userdefaults Data base
    //or grabs the default settings if the database has not been populated yet
    var globalSettings:ChessSettings = ChessSettings()    
    
    //MARK: - View Controller Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.clearsSelectionOnViewWillAppear = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update()
    }
    
    //MARK: setup the initial state of the VC with the current settings
    private func update(){
        //set position of animation switch
        animationSwitch.isOn = globalSettings[ChessSettings.Key.animationsEnabled] as! Bool
        //set position of notificaiton switch
        notificationsSwitch.isOn = globalSettings[ChessSettings.Key.notificationsEnabled] as! Bool
        //set label of chessboard theme cell
        let previouslySelectedChessBoardTheme = globalSettings[ChessSettings.Key.chessBoardTheme] as! ChessBoardTheme
        let chessBoardThemeText = chessBoardThemeTexts[previouslySelectedChessBoardTheme]
        chessBoardThemeCurrentSelectionLabel.text = chessBoardThemeText
    }

   //MARK: - Actions
    
    @IBAction func chessNotificationsSwitchValueChanged(_ sender: UISwitch) {
        globalSettings[ChessSettings.Key.notificationsEnabled] = sender.isOn
    }

    @IBAction func animationsSwitchValueChanged(_ sender: UISwitch) {
        globalSettings[ChessSettings.Key.animationsEnabled] = sender.isOn
    }
    
    @IBAction func chessClockSwitchValueChanged(_ sender: UISwitch) {
        sender.isOn ? enable(cell: clockTimeCell) : disable(cell: clockTimeCell)

    }

    @IBAction func takeBacksSwitchValueChanged(_ sender: UISwitch) {
        sender.isOn ? enable(cell: maxTakeBacksCell) : disable(cell: maxTakeBacksCell)
    }

   
    //MARK: - Outlets
    @IBOutlet weak var animationSwitch: UISwitch!

    @IBOutlet weak var notificationsSwitch: UISwitch!
    
    @IBOutlet weak var clockTimeCell: UITableViewCell!
    @IBOutlet weak var maxTakeBacksCell: UITableViewCell!
    

    @IBOutlet weak var chessBoardThemeCurrentSelectionLabel: UILabel!
    

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
        chessBoardThemeCollectionVC.selectedTheme = globalSettings[ChessSettings.Key.chessBoardTheme] as! ChessBoardTheme!
    }
    
    


}
