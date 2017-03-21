//
//  MaxTakebackViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-16.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

enum TakeBackCount{
    case Finite(Int)
    case Infinite
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
    
    private var interpretedData:TakeBackCount{
        if integerData == Int(maxSliderValue){
            return TakeBackCount.Infinite
        }else{
            return TakeBackCount.Finite(integerData)
        }
    }
    


}
