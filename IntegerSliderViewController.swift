//
//  IntegerSliderViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-16.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit
import Foundation

class IntegerSliderViewController: SliderViewController {
    
    //MARK: -  Conversion from Float to Int
    
    private func floatToInt(float:Float)->Int{
        return Int(round(float))
    }
    
    //MARK: - max slider value
    internal var maxIntegerSliderValue:Int{
        return floatToInt(float: maxSliderValue)
    }
    
    //MARK: - Model
    internal var integerData: Int{
        get{
            return floatToInt(float: data)
        }
        set{
            data = Float(integerData)
        }
    }
    
    //MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    //MARK: - Displaying integer data
    override func dataDisplayer()->String{
        return String(integerData)
    }
    
    //MARK : - Setup
    //MARK: Setting initial slider value
    internal func  setInitialSliderValue(toIntegerValue integerValue:Int)->Bool{
        guard super.setInitialSliderValue(to: Float(integerValue)) else { return false}
        integerData = integerValue
        return true
    }
    //MARK: Setting max min slider values
    internal func setMinMaxIntegerSliderValues(min: Int,max:Int){
        super.setMinMaxSliderValues(min: Float(min), max: Float(max))
    }
    

}
