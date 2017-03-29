//
//  ClockTimeViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-20.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class ClockTimeViewController: IntegerSliderViewController {
  struct Constants{
        static let maxClockTime = 90 //90 mintues
        static let minClockTime = 1  //1 minute
    }
    
    struct Default{
        static let clockTime: Int = 5 * 60 // 5 minutes
    }
    
    //MARK: - Model
    internal var clockTime:Int = Default.clockTime
    
    //MARK: updating Model
    override func updateModel(givenCurrentInteger sliderValue: Int) {
        clockTime = sliderValue * 60
    }
    
    private var minutes: Int{
        return clockTime / 60
    }
    
    //MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        exitClosure = updateGameSettings
        _ = minMaxSliderValues(intMin: Constants.minClockTime, intMax: Constants.maxClockTime)
        _ = initialSliderValue(intValue: minutes)
    }

    
    //MARK: - Customization of Integer Slider VC

    //MARK: - Converting Integer Data to String
    override internal func toString(intData: Int) -> String {
        var timeFormatter = TimeFormatter()
        timeFormatter.totalSeconds = intData * 60
        return timeFormatter.hoursMinutesString
    }
    
    
    //MARK: - Update VC returned to with final slider data
    //Overide this method in subclasses
    private func updateGameSettings(){
        guard let gameSettingsVC = self.previousViewController as? ChessGameSettingsTableTableViewController else{return}
        gameSettingsVC.gameSettings.clockTime = clockTime
    }
}
