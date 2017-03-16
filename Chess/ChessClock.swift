//
//  ChessClock.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-13.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class ChessClock{
    let whiteTimer:ChessTimer
    let blackTimer:ChessTimer
    var clockStarted = false
    var timerToUnPause: ChessTimer? = nil
    var history: [(TimeInterval,TimeInterval)]
    var delegate: ChessClockDelegate? = nil
    
    //returns whether or not one of the timers ran out of time
    var timeIsUp:Bool{
        return blackTimer.timeIsUp || whiteTimer.timeIsUp
    }
    
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
    
    //TODO: Make method that alows you to set the time of a timer 
    
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
    
    //MARK: Initializers
    init(with seconds:Int){
        self.whiteTimer = ChessTimer(with: seconds)
        self.blackTimer = ChessTimer(with: seconds)
        self.history = [(TimeInterval(seconds),TimeInterval(seconds))]
        self.whiteTimer.timerCompletionHandler = {self.timerUp(for: .White)}
        self.blackTimer.timerCompletionHandler = {self.timerUp(for: .Black)}
    }
    
    
}
