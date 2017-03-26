//
//  ClockTimeViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-20.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class ClockTimeViewController: IntegerSliderViewController {
    
    //MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        exitClosure = updateGameSettings
        // Do any additional setup after loading the view.
    }
    
    
    
    //MARK: - Customization of Integer Slider VC

    override func dataDisplayer()->String{
        var timeFormatter = TimeFormatter()
        timeFormatter.totalSeconds = integerData * 60
        return timeFormatter.hoursMinutesString
    }

    
    private var interpretedData:Int{
        return integerData * 60// convert minutes to seconds
    }
    
    //MARK: - Update VC returned to with final slider data
    //Overide this method in subclasses
    private func updateGameSettings(){
        guard let gameSettingsVC = self.previousViewController as? ChessGameSettingsTableTableViewController else{return}
        gameSettingsVC.chessClock = ChessClock(with: interpretedData)
    }
}
