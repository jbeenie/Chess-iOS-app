//
//  MenuViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-15.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    
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
        if let chessGameVC = segue.destination.contentViewController as? ChessGameViewController{
            //TODO: Get the Chess Game settings via user feedback
            
            //For now just create a chessgame settings manually
            let takebackCount = TakebackCount.Finite(2)
            let chessClock:ChessClock? = ChessClock(with: 500)
            let chessGameSettings = ChessGameSettings(maxTakebacks: takebackCount, chessClock: chessClock)
            
            //Give it the latest version of the global settings
            chessGameSettings.globalSettings = ImmutableChessSettings()
            chessGameVC.gameSettings = chessGameSettings
        }
    }


}
