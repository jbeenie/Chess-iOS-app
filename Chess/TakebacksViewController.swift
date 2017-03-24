//
//  TakebacksViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-23.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class TakebacksViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var takebackCountLabel: UILabel!

    //MARK: - Model
    internal var takebackCount: TakebackCount! = nil{
        didSet{
            updateTakebackCountLabel()
        }
    }
    
    //MARK: updating take back count
    
    private func updateTakebackCountLabel() {
        if let takebackCount = takebackCount{
            takebackCountLabel?.text = takebackCount.description
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let takebackCount = takebackCount{
            takebackCountLabel?.text = takebackCount.description
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
