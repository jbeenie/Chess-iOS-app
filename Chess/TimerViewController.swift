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
    var totalSeconds:TimeInterval = 45 //in seconds
    //Object used to convert total number of seconds into
    var timeFormatter: TimeFormatter = TimeFormatter()
    //timer object used to update timer display at regular interval
    var timer = Timer()
    var timerIsRunning = false
    //The increment of time between timer updates
    let increment:TimeInterval = 1//seconds
    //closure to execute when timer ends
    var timerCompletionHandler: (()->Void)? = nil
    //mode of operation
    let mode: Mode = .CountDown
    
    
    
    
    //MARK: - Methods
    
    private func incrementTime()
    {
        totalSeconds += increment
        updateTimerLabel()
    }
    
    private func decrementTime(){
        totalSeconds -= increment
        updateTimerLabel()
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
        timeFormatter.totalSeconds = Int(totalSeconds)
        timerLabel.text = timeFormatter.simpleTimeString
        timerLabel.setNeedsDisplay()
    }
    
    func resume(){
        //if the the timer is already running do nothing
        if timerIsRunning{return}
        //otherwise restart it
        timer = Timer.scheduledTimer(timeInterval: increment, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        timerIsRunning = true
    }
    
    func pause(){
        timer.invalidate()
        timerIsRunning = false
        
    }
    
    func reset(to totalSeconds:TimeInterval){
        timer.invalidate()
        timerIsRunning = false
        self.totalSeconds = totalSeconds
        updateTimerLabel()
    }
    
    
    //MArK: - Actions
    
    @IBAction func startButtonPressed(_ sender: UIButton)
    {
        resume()
    }
    @IBAction func pauseButtonPressed(_ sender: AnyObject)
    {
        pause()
    }
    @IBAction func resetButtonPressed(_ sender: AnyObject)
    {
        reset(to: 0)
    }
    
    
    //MARK: - View Controller Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        timerLabel.textAlignment = .left
        updateTimerLabel()
    }
    
    
}


