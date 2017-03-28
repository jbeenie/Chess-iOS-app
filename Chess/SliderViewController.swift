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
    //MARK: - Processing slider value in String
    private var displayString:String{
        return dataToString(slider.value)
    }
    
    private lazy var dataToString: (Float)->String = {"\($0)"}

    //MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        self.tableView.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        exitClosure?()
    }
    
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var dataLabel: UILabel!
   
    //MARK: - Actions
    @IBAction func sliderMoved(_ sender: UISlider) {
        updateUI()
        updateModel(givenCurrent: sender.value)
    }
    
    //MARK: Helper methods
    private func updateUI(){
        dataLabel?.text =  displayString
    }
    
    internal func updateModel(givenCurrent sliderValue:Float){}
    
    
    //MARK:Configuring Slider
    
    internal func  initialSliderValue(value:Float)->Bool{
        guard value <= slider.maximumValue || value >= slider.minimumValue else {return false}
        slider.value = value
        return true
    }
    
    internal func minMaxSliderValues(min: Float,max:Float)->Bool{
        guard min < max else {return false}
        slider.minimumValue = min
        slider.maximumValue = max
        return true
    }
    
    //Specify how each slider value in the range should be displayed
    internal func mapDataToString(with map: @escaping (Float)->String){
        dataToString = map
    }
    
    //Set this closure to what ever function you want to execute
    //when VC disappears
    internal var exitClosure: (()->Void)? = nil
    
   
}
