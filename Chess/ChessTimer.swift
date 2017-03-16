//
//  ChessTimer.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-13.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class ChessTimer {
    //enum defining different modes of operation for the timer
    
    //MARK: - Stored Properties
    //closure to execute when timer ends
    var timerCompletionHandler: (()->Void)? = nil
    
    //running or not
    var isRunning:Bool{
        return _isRunning
    }
    
    var delegate:ChessTimerDelegate!
    
    //MARK: Private
    let initialTotalSeconds:Int
    
    //time left on timer
    private var totalSeconds:TimeInterval{//in seconds
        didSet{
            let secondsToDisplay = ceil(totalSeconds)
            //Update the timer display
            delegate.updateTimerDisplay(with:Int(secondsToDisplay))
        }
    }
    
    
    //timer object used to update timer display at regular interval
    private var timer = Timer()
    private var _isRunning = false
    //The increment of time between timer updates
    private let timeIncrement:TimeInterval = 0.25//seconds
    
    
    
    //MARK: - Methods
    //MARK: Private
    
    private func incrementTime() {totalSeconds += timeIncrement}
    
    private func decrementTime(){
        totalSeconds -= timeIncrement
        //if the timer is up
        if totalSeconds == 0{
            pause()
            timerCompletionHandler?()
            pause()
        }
    }
    
    @objc private func updateTime(){
        decrementTime()
    }
    
    //MARK: API
    var timeRemaining:TimeInterval{
        return totalSeconds
    }
    
    var timeIsUp:Bool{
        return timeRemaining == 0
    }
    
    func setInitialTime(to initialTime: Int){
            totalSeconds = TimeInterval(initialTime > 0 ? initialTime : 0)
    }
    
    func resume(){
        //if the the timer is already running do nothing
        if isRunning{return}
        //otherwise restart it
        timer = Timer.scheduledTimer(timeInterval: timeIncrement, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        _isRunning = true
    }
    
    func pause(){
        timer.invalidate()
        _isRunning = false
    }
    
    
    
    func reset(to totalSeconds:TimeInterval? = nil){
        timer.invalidate()
        _isRunning = false
        self.totalSeconds = totalSeconds ?? TimeInterval(initialTotalSeconds)
    }
    
    //MARK: Initializers
    
    init(with seconds:Int){
        self.totalSeconds = TimeInterval(seconds)
        self.initialTotalSeconds = seconds
    }
}
