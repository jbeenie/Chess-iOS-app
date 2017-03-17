//
//  TimeControlViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-16.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class TimeControlViewController: IntegerSliderViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override var integerDataDisplayer:(Int)->String{
        get{
            return {data in return self.display(minutesData: data)}
        }
        set{}
    }
    
    private func display(minutesData:Int)->String{
        var timeFormatter = TimeFormatter()
        timeFormatter.totalSeconds = integerData * 60
        return timeFormatter.hoursMinutesString
    }
    
    private var interpretedData:ClockTime{
        var timeFormatter = TimeFormatter()
        timeFormatter.totalSeconds = integerData * 60
         let (h,m,_) = timeFormatter.hoursMinutesAndSeconds
        return ClockTime(hours:h,minutes:m)
    }
    
    struct ClockTime{
        let hours:Int
        let minutes:Int
    }

}
