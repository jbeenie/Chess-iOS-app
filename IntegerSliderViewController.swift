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

    //MARK: - Model
    var integerData: Int{
        return Int(round(data))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    var integerDataDisplayer:(Int)->String = { data in
        return String(data)
    }
    

    override var dataDisplayer: (Float) -> String {
        get{
            return {data in self.integerDataDisplayer(self.integerData)}
        }
        set{}            
    }
}
