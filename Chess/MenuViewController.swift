//
//  MenuViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-15.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    //MARK: - Model
    
    private var globalSettings = ChessSettings()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide the navigation bar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    
    
    
    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //extract the desired destination view controller if it is inside of a navigation view controller
        //cast the destination view controller to the appropriate view controller subclass: Settings View Controller
        if let settingsVC = segue.destination.contentViewController as? SettingsTableViewController{
            //prepare settings VC with NSUserDefaults
            print("******prepare for settings*********")
            //TODO: Prepare Settings VC with NS User defaults
            //Create a settings model object  that you load with the 
            //NSUSER defaults data which updates the settings accordingly
        }else if let chessGameVC = segue.destination.contentViewController as? ChessGameViewController{
            //TODO: Prepare the Chess game VC with the NSUSER Defaults
            print("*********prepare for chess game*********")
        }
    }


}
