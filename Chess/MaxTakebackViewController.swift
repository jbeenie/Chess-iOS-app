//
//  MaxTakebackViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-16.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

enum TakebackCount{
    case Finite(Int)
    case Infinite
    
    var isZero:Bool{
        switch self{
        case .Finite(let count):
            return count == 0
        case .Infinite:
            return false
        }
    }
    
    mutating func decrement(){
        switch self{
        case .Finite(let count):
            let newCount = count>0 ? count-1 : count
            self = TakebackCount.Finite(newCount)
        case .Infinite:
            break
        }
    }
    
    mutating func incrementIfLess(than maxTakeBackCount:TakebackCount){
        switch (self,maxTakeBackCount){
        case (.Finite(let count),.Finite(let maxCount)):
            let newCount = maxCount>count ? count+1 : count
            self = TakebackCount.Finite(newCount)
        default:
            break
        }
    }
    
    var description:String{
        switch self{
        case .Finite(let count):
            return String(count)
        case .Infinite:
            return "∞"
        }
    }
}

class MaxTakebackViewController: IntegerSliderViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var integerDataDisplayer:(Int)->String{
        get{
            return {data in return self.display(takeBacksData: data)}
        }
        set{}
    }
    
    private func display(takeBacksData:Int)->String{
        if takeBacksData == Int(maxSliderValue){
            return "∞"
        }else{
            return String(takeBacksData)
        }
    }
    
    private var interpretedData:TakebackCount{
        if integerData == Int(maxSliderValue){
            return TakebackCount.Infinite
        }else{
            return TakebackCount.Finite(integerData)
        }
    }
    


}
