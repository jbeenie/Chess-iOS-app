//
//  SliderViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-16.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class SliderViewController: UITableViewController
{
    //MARK: - Configuration
    internal var minSliderValue:Float = 0
    internal var maxSliderValue:Float = 1
    
    
    //MARK: - Model
    
    internal var data:Float = 0
    
    internal func dataDisplayer()->String{
        return String(self.data)
    }

    
    
    //MARK: -Processing of Model
    private var displayString:String{
        return dataDisplayer()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        slider?.maximumValue = maxSliderValue
        slider?.minimumValue = minSliderValue
        slider.value = data
        dataLabel.text = displayString
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        exitClosure?()
    }
    
    //Set this closure to what ever function you want to execute
    //when VC disappears
    internal var exitClosure: (()->Void)? = nil
    
    //MARK: - Outlets
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var dataLabel: UILabel!
   
    //MARK: - Actions
    @IBAction func sliderMoved(_ sender: UISlider) {
        data = slider.value
        updateUI()
    }
    
    //MARK: Helper methods
    private func updateUI(){
        dataLabel.text =  displayString
    }
    
    internal func  setInitialSliderValue(to value:Float)->Bool{
        guard value <= maxSliderValue && value >= minSliderValue else {return true}
        data = value
        return true
    }
    
    internal func setMinMaxSliderValues(min: Float,max:Float){
        minSliderValue = min
        maxSliderValue = max
    }
    
   
}
