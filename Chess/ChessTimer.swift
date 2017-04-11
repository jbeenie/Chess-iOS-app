//
//  ChessTimer.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-13.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class ChessTimer:NSObject,NSCoding {
    
    //MARK: - Stored Properties
    //closure to execute when timer ends
    var timerCompletionHandler: (()->Void)? = nil
    
    var delegate:ChessTimerDelegate!
    
    let initialSeconds:Int

    //MARK: Private
    
    //time left on timer
    private var secondsRemaining:TimeInterval{//in seconds
        didSet{
            let secondsToDisplay = ceil(secondsRemaining)
            //Update the timer display
            delegate.updateTimerDisplay(with:Int(secondsToDisplay))
        }
    }
    
    //timer object used to update timer display at regular interval
    private var timer = Timer()
    private var _isRunning = false
    //The increment of time between timer updates
    private let timeIncrement:TimeInterval = 0.25//seconds
    
    //MARK: - Computed Properties
    
    //running or not
    var isRunning:Bool{
        return _isRunning
    }
    
    
    //MARK: - Methods
    //MARK: Private
    
    private func incrementTime() {secondsRemaining += timeIncrement}
    
    private func decrementTime(){
        secondsRemaining -= timeIncrement
        //if the timer is up
        if secondsRemaining == 0{
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
        return secondsRemaining
    }
    
    var timeIsUp:Bool{
        return timeRemaining == 0
    }
    
    func setInitialTime(to initialTime: Int){
            secondsRemaining = TimeInterval(initialTime > 0 ? initialTime : 0)
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
        self.secondsRemaining = totalSeconds ?? TimeInterval(initialSeconds)
    }
    
    //MARK: - Debugging
    override var description: String{
        return "initialSeconds: \(initialSeconds)\n" +
            "secondsRemaining: \(secondsRemaining)\n" +
            "delegate: \(String(describing: delegate))\n" +
            "timerCompletionHandler: \(String(describing: timerCompletionHandler))\n"
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(initialSeconds, forKey: "initialSeconds")
        aCoder.encode(secondsRemaining, forKey: "secondsRemaining")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(
            initialSeconds: aDecoder.decodeInteger(forKey:"initialSeconds"),
            secondsRemaining: aDecoder.decodeDouble(forKey:"secondsRemaining"))
    }
    
    //MARK: Initializers
    
    convenience init(initialSeconds:Int){
        self.init(initialSeconds: initialSeconds, secondsRemaining: TimeInterval(initialSeconds))
    }
    
    init(initialSeconds:Int, secondsRemaining:TimeInterval){
        self.secondsRemaining = secondsRemaining
        self.initialSeconds = initialSeconds
        super.init()
    }
}
