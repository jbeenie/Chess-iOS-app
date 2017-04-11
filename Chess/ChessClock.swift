//
//  ChessClock.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-13.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class ChessClock:NSObject,NSCoding{
    //MARK: - Stored Properties
    let whiteTimer:ChessTimer
    let blackTimer:ChessTimer
    var clockStarted:Bool
    var timerToUnPause: ChessTimer?
    var history: [(TimeInterval,TimeInterval)]
    var delegate: ChessClockDelegate? = nil
    let initialTime:Int//in seconds
    
    //MARK: - Computed Properties
    //returns whether or not one of the timers ran out of time
    var timeIsUp:Bool{
        return blackTimer.timeIsUp || whiteTimer.timeIsUp
    }
    
    //MARK: - Methods
    private func timerUp(for color:ChessPieceColor){
        self.pause()
        delegate?.timerUp(for: color)
    }
    
    //MARK: - Start the clock
    func start(){
        if !clockStarted{
            whiteTimer.resume()
            clockStarted = true
        }
    }
    
    //Stops one timer and resumes the other
    private func toggleTimers(){
        //first ensure the timers are enable
        let (timerToResume,timerToPause) = whiteTimer.isRunning ? (blackTimer, whiteTimer) : (whiteTimer, blackTimer)
        timerToPause.pause()
        timerToResume.resume()
    }
    
    func moveOccured(){
        history.append((whiteTimer.timeRemaining,blackTimer.timeRemaining))
        //DEbugging
        var timeFromatter = TimeFormatter()
        timeFromatter.totalSeconds = Int(whiteTimer.timeRemaining)
        print("white time remaining: \(timeFromatter.hoursMinutesAndSeconds)")
        timeFromatter.totalSeconds = Int(blackTimer.timeRemaining)
        print("black time remaining: \(timeFromatter.hoursMinutesAndSeconds)")
        toggleTimers()
    }
    
    func moveUndone(){
        //can only roll back clock if atleast one move has already occured
        guard history.count >= 2 else{return}
        //if this condition is met roll back the clock
        //check the last state of the clock
        _ = history.popLast()
        //set it to the state before that one
        if let (previousWhiteTime,previousBlackTime) = history.last{
            let timerToResume = whiteTimer.isRunning ? blackTimer : whiteTimer
            whiteTimer.reset(to: previousWhiteTime)
            blackTimer.reset(to: previousBlackTime)
            timerToResume.resume()
        }
    }
    
    func pause(){
        //make sure clock is started and clock is not paused already
        guard clockStarted, timerToUnPause == nil else{return}
        //get the timer to pause and pause it
        let timerToPause = whiteTimer.isRunning ? whiteTimer : blackTimer
        timerToPause.pause()
        //set the timer to unPause
        timerToUnPause = timerToPause
    }
    func unPause(){
        timerToUnPause?.resume()
    }
    
    func reset(){
        //first ensure the timers are enable
        whiteTimer.reset()
        blackTimer.reset()
        clockStarted = false
    }
    
    //MARK: - Debugging
    
    override var description: String{
        return "whiteTimer:\n \(whiteTimer)\n" +
        "blackTimer:\n \(blackTimer)\n" +
        "clockStarted: \(clockStarted)\n" +
        "timerToUnPause:\n \(String(describing: timerToUnPause))\n" +
        "history: \(history)\n" +
        "delegate: \(String(describing: delegate))\n" +
        "initialTime: \(initialTime)\n"
    }
    
    //MARK: - NSCoding
    
    func encode(with aCoder: NSCoder) {
        let timerToUnPauseString:String? = timerToUnPause === whiteTimer ? "W" : (timerToUnPause === blackTimer ? "B" : nil)
        aCoder.encode(timerToUnPauseString, forKey: "timerToUnPause")//ChessTimer?
        aCoder.encode(self.whiteTimer, forKey: "whiteTimer")//ChessTimer
        aCoder.encode(self.blackTimer, forKey: "blackTimer")//ChessTimer
        aCoder.encode(self.clockStarted, forKey: "clockStarted")//Bool
        aCoder.encode(self.initialTime, forKey: "initialTime")//Int
        //convert history to array of 2 element arrays then encode it
        aCoder.encode(self.history.map { [$0.0, $0.1] }, forKey: "history")//[(TimeInterval,TimeInterval)]
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let whiteTimer = aDecoder.decodeObject(forKey:"whiteTimer") as? ChessTimer,
            let blackTimer = aDecoder.decodeObject(forKey:"blackTimer") as? ChessTimer,
            let history = aDecoder.decodeObject(forKey:"history") as? [[TimeInterval]]
            else{ return nil }
        
        let timerToUnPauseString = aDecoder.decodeObject(forKey:"timerToUnPause") as? String
        let timerToUnPause:ChessTimer? = (timerToUnPauseString == "W") ? whiteTimer : (timerToUnPauseString == "B" ? blackTimer : nil)

        
        self.init(
            with: aDecoder.decodeInteger(forKey:"initialTime"),
            whiteTimer: whiteTimer,
            blackTimer: blackTimer,
            clockStarted: aDecoder.decodeBool(forKey:"clockStarted"),
            history: history.map { ($0[0], $0[1]) },
            timerToUnPause: timerToUnPause)
    }
    
    
    
    //MARK: Initializers
    convenience init(with seconds:Int){
        self.init(with: seconds,
                  whiteTimer: ChessTimer(initialSeconds: seconds),
                  blackTimer: ChessTimer(initialSeconds: seconds),
                  clockStarted: false,
                  history: [(TimeInterval(seconds),TimeInterval(seconds))])
    }
    
    init(with seconds:Int,
         whiteTimer:ChessTimer,
         blackTimer:ChessTimer,
         clockStarted:Bool,
         history:[(TimeInterval,TimeInterval)],
         timerToUnPause:ChessTimer?=nil){
        //initialize your own properties
        self.initialTime = seconds
        self.whiteTimer = whiteTimer
        self.blackTimer = blackTimer
        self.clockStarted = clockStarted
        self.history = history
        self.timerToUnPause = timerToUnPause
        //initialize superclass properties
        super.init()
        //customization
        self.whiteTimer.timerCompletionHandler = {self.timerUp(for: .White)}
        self.blackTimer.timerCompletionHandler = {self.timerUp(for: .Black)}
    }
}
