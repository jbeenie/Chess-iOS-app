//
//  TimerViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-12.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    //enum defining different modes of operation fo the timer
    enum Mode{
        case CountUp,CountDown
    }
    
    //MARK: - Outlets
    @IBOutlet weak var timerLabel: UILabel!
    
    //MARK: - Stored Properties
    //Total Number of seconds elapsed on timer
    //closure to execute when timer ends
    var timerCompletionHandler: (()->Void)? = nil
    //mode of operation
    var mode: Mode = .CountDown
    
    //MARK: Private
    private var totalSeconds:Int = 45 {//in seconds
        didSet{
            updateTimerLabel()
        }
    }
    //Object used to convert total number of seconds into
    private var timeFormatter: TimeFormatter = TimeFormatter()
    //timer object used to update timer display at regular interval
    private var timer = Timer()
    private var timerIsRunning = false
    //The increment of time between timer updates
    private let increment:Int = 1//seconds
    private var timeIncrement:TimeInterval{
        return TimeInterval(increment)
    }
    
    
    
    
    
    //MARK: - Methods
    //MARK: Private
    private func incrementTime() {totalSeconds += increment}
    
    private func decrementTime(){
        totalSeconds -= increment
        if totalSeconds == 0{
            pause()
            timerCompletionHandler?()
            print("done")
        }
    }
    
    @objc private func updateTime(){
        mode == .CountDown ? decrementTime() : incrementTime()
    }
    
    private func updateTimerLabel(){
        timeFormatter.totalSeconds = totalSeconds
        timerLabel.text = timeFormatter.simpleTimeString
        timerLabel.setNeedsDisplay()
    }
    
    //MARK: API
    func setInitialTime(to initialTime: Int){
        if mode == .CountDown{
            totalSeconds = initialTime > 0 ? initialTime : 0
        }
    }
    
    func resume(){
        //if the the timer is already running do nothing
        if timerIsRunning{return}
        //otherwise restart it
        timer = Timer.scheduledTimer(timeInterval: timeIncrement, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        timerIsRunning = true
    }
    
    func pause(){
        timer.invalidate()
        timerIsRunning = false
        
    }
    
    func reset(to totalSeconds:Int){
        timer.invalidate()
        timerIsRunning = false
        self.totalSeconds = totalSeconds
    }
    
    

    //MARK: - View Controller Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        timerLabel.textAlignment = .left
        updateTimerLabel()
    }
    
    
}


