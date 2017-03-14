//
//  TimerViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-12.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController,ChessTimerDelegate{
    //MARK: - Outlets
    @IBOutlet weak var timerLabel: UILabel!
    
    //MARK: Model
    var timer: ChessTimer?{
        didSet{
            timer?.delegate = self
            setUpTimerLabel()
        }
    }
    
    //MARK: - Stored Properties

    //Object used to convert total number of seconds into
    private var timeFormatter: TimeFormatter = TimeFormatter()
    
    //MARK: Conform to ChessTimerDelegate
    
    func updateTimerDisplay(with seconds:Int) {
        timeFormatter.totalSeconds = seconds
        timerLabel?.text = timeFormatter.simpleTimeString
        timerLabel?.setNeedsDisplay()
    }
    
    private func setUpTimerLabel(){
        //if the timer is not nil
        if let timer = self.timer{
            //set the label to the initial time on the timer
            updateTimerDisplay(with:timer.initialTotalSeconds)
        }else{
            //otherwise dont display anything
            timerLabel?.text = nil
        }
    }
    

    //MARK: - View Controller Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        timerLabel.textAlignment = .left
        setUpTimerLabel()
    }
}


