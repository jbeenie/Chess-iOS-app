//
//  SettingsTableViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-15.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit
import Themeable

class SettingsTableViewController: ThemeableTableViewController {
    
    struct StoryBoard{
        static let ChessBoardThemeSegue = "ChessBoardTheme"
    }
    
    struct Constants{
        static let shouldHighlightRowAt:[IndexPath:Bool] = [
            IndexPath(row: 0, section: 0):false,
            IndexPath(row: 0, section: 1):false,
            IndexPath(row: 0, section: 2):true
            
        ]
    }
    
    private var chessBoardThemeTexts:[ChessBoardTheme:String]{
        var chessBoardThemeTexts = [ChessBoardTheme:String]()
        for chessBoardTheme in ChessBoardThemes.list{
            chessBoardThemeTexts[chessBoardTheme] = chessBoardTheme.name
        }
        return chessBoardThemeTexts
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
        //Debug:
        print(UserDefaults.standard.dictionaryRepresentation())
        
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
    //Switches
    @IBOutlet weak var animationSwitch: UISwitch!
    @IBOutlet weak var notificationsSwitch: UISwitch!
    //Labels
    
    @IBOutlet weak var chessNotificationLabel: UILabel!
    @IBOutlet weak var animationsLabel: UILabel!
    @IBOutlet weak var ChessBoardThemeLabel: UILabel!
    @IBOutlet weak var chessBoardThemeCurrentSelectionLabel: UILabel!
    
    
    
    //MARK: - Cusotmizing TableViewController
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return Constants.shouldHighlightRowAt[indexPath]!
    }

    
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
        chessBoardThemeCollectionVC.selectedTheme = globalSettings[ChessSettings.Key.chessBoardTheme] as! ChessBoardTheme
    }
    
    //MARK: - Cusotmizing Themeable Conformance
    override func apply(theme: AppTheme) {
        super.apply(theme: theme)
        //Section 1 Cell 1
        //Left
        self.chessNotificationLabel.textColor = theme.tableViewCellLeftTextColor
        
        //Section 2 Cell 1
        //Left
        self.animationsLabel.textColor = theme.tableViewCellLeftTextColor
        
        //Section 3 Cell 1
        //Left
        self.ChessBoardThemeLabel.textColor = theme.tableViewCellLeftTextColor
        //Right
        self.chessBoardThemeCurrentSelectionLabel.textColor = theme.tableViewCellRightTextColor
        
    }
    


}
