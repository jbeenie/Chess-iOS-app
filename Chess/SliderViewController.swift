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
    @IBInspectable
    internal var minSliderValue:Float = 0
    @IBInspectable
    internal var maxSliderValue:Float = 1
    
    internal let initialSliderValue:Float = 0
    
    //MARK: - Model
    
    var data:Float = 0
    
    var dataDisplayer:(Float)->String = {data in return String(data)}

    
    
    //MARK: -Processing of Model
    private var displayString:String{
        return dataDisplayer(data)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.value = initialSliderValue
        dataLabel.text = dataDisplayer(initialSliderValue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        slider?.maximumValue = maxSliderValue
        slider?.minimumValue = minSliderValue
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        exitClosure?()
    }
    
    //Set this closure to what ever function you want to execute
    //when VC disappears
    var exitClosure: (()->Void)? = nil
    
    //MARK: - Outlets
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var dataLabel: UILabel!
   
    //MARK: - Actions
    @IBAction func sliderMoved(_ sender: UISlider) {
        data = slider.value
        updateUI()
    }
    
    private func updateUI(){
        dataLabel.text =  displayString
    }
    
   
}
