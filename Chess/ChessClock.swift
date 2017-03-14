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
    var history: [(TimeInterval,TimeInterval)] = [(TimeInterval,TimeInterval)]()
    
    //MARK: - Start the clock
    func startClock(){
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
        toggleTimers()
    }
    
    //TODO: Make method that alows you to set the time of a timer 
    
    func moveUndone(){
        if let (previousWhiteTime,previousBlackTime) = history.popLast(){
            let timerToResume = whiteTimer.isRunning ? blackTimer : whiteTimer
            whiteTimer.reset(to: previousWhiteTime)
            blackTimer.reset(to: previousBlackTime)
            timerToResume.resume()
            toggleTimers()
        }
    }
    
    func resetClock(){
        //first ensure the timers are enable
        whiteTimer.reset()
        blackTimer.reset()
        clockStarted = false
    }
    
    //MARK: Initializers
    init(with seconds:Int){
        self.whiteTimer = ChessTimer(with: seconds)
        self.blackTimer = ChessTimer(with: seconds)
    }
    
    
}
