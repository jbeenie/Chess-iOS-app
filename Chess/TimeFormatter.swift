//
//  TimeFormatter.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-12.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

struct TimeFormatter{
    
    private var _totalSeconds: Int = 0
    
    var totalSeconds: Int{
        get{
            return _totalSeconds
        }
        set{
            _totalSeconds = newValue > 0 ? newValue : 0
        }
    }
    
    var years: Int {
        return totalSeconds / 31536000
    }
    
    var days: Int {
        return (totalSeconds % 31536000) / 86400
    }
    
    var hours: Int {
        return (totalSeconds % 86400) / 3600
    }
    
    var minutes: Int {
        return (totalSeconds % 3600) / 60
    }
    
    var seconds: Int {
        return totalSeconds % 60
    }
    
    var hoursMinutesAndSeconds:(hours: Int, minutes: Int, seconds: Int) {
        return (hours, minutes, seconds)
    }
    
    var hoursMinutesSecondsString: String {
        let hoursText = hours
        let minutesText = zeroPaddedTimeText(from: minutes)
        let secondsText = zeroPaddedTimeText(from: seconds)
        return "\(hoursText):\(minutesText):\(secondsText)"
    }
    
    var hoursMinutesString:String{
        let hoursText = hours
        let minutesText = zeroPaddedTimeText(from: minutes)
        return "\(hoursText):\(minutesText)"
    }
    
    private func zeroPaddedTimeText(from number: Int) -> String {
        return number < 10 ? "0\(number)" : "\(number)"
    }
}
