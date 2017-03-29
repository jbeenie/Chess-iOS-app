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
    
    var maximumIntegerValue:Int{
        return roundToInt(float: slider.maximumValue)
    }
    
    var minimumIntegerValue:Int{
        return roundToInt(float: slider.minimumValue)
    }
    
    var integerValue:Int{
        get{
            return roundToInt(float: slider.value)
        }
        set{
            slider.value = Float(integerValue)
        }
    }
    
    //MARK: -  Conversion from Float to Int
    
    private func roundToInt(float:Float)->Int{
        return Int(round(float))
    }
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapIntegerDataToString(with: toString(intData:))
    }
    
    override internal final func updateModel(givenCurrent sliderValue: Float) {
        updateModel(givenCurrentInteger: roundToInt(float: sliderValue))
    }
    
    internal func updateModel(givenCurrentInteger sliderValue: Int){
        
    }
    
    //MARK:Configuring Slider
    
    internal func  initialSliderValue(intValue:Int)->Bool{
        let floatValue = Float(intValue)
        guard floatValue <= slider.maximumValue || floatValue >= slider.minimumValue else {return false}
        slider.value = floatValue
        return true
    }
    
    internal func minMaxSliderValues(intMin: Int,intMax:Int)->Bool{
        guard intMin < intMax else {return false}
        slider.minimumValue = Float(intMin)
        slider.maximumValue = Float(intMax)
        return true
    }
    
    //Specify how each slider value in the range should be displayed
    internal func mapIntegerDataToString(with integerMap: @escaping (Int)->String){
        let map:(Float)->String = { data in
            let integerData = self.roundToInt(float: data)
            return integerMap(integerData)
        }
        super.mapDataToString(with: map)
    }
    
    //MARK: - Converting Integer Data to String
    internal func toString(intData: Int)->String{
        return "\(intData)"
    }
    
    

}
