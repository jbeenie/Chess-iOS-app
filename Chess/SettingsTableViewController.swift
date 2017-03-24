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
    

   
    //MARK: - Outlets
    @IBOutlet weak var animationSwitch: UISwitch!

    @IBOutlet weak var notificationsSwitch: UISwitch!
    

    @IBOutlet weak var chessBoardThemeCurrentSelectionLabel: UILabel!
    


    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        if identifier == StoryBoard.ChessBoardThemeSegue{
            prepare(chessBoardThemeCollectionVC:(segue.destination.contentViewController as! ChessBoardThemeCollectionViewController))
        }
    }
    

    
    private func prepare(chessBoardThemeCollectionVC:ChessBoardThemeCollectionViewController){
        //select the appropriate chess theme to indicate
        //the theme that was chosen last
        chessBoardThemeCollectionVC.selectedTheme = globalSettings[ChessSettings.Key.chessBoardTheme] as! ChessBoardTheme!
    }
    
    


}
