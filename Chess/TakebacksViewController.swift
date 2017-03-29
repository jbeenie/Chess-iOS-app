//
//  TakebacksViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-23.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class TakebacksViewController: UIViewController {

    struct Constants{
        static let fontSizeRatio = 0.6
    }
    
    //MARK: - Outlets
    @IBOutlet weak var takebackCountLabel: UILabel!
    
    var takebackIcon:UIImage?{
        guard let takebackIcon = UIImage(named: "takebackIcon.png") else{ return nil}
        let iconSize = takebackCountLabel.frame.size
        return UIImage.resizeImage(image: takebackIcon, targetSize: iconSize)
    }

    //MARK: - Model
    internal var takebackCount: TakebackCount! = nil{
        didSet{
            updateTakebackCountLabel()
        }
    }
    
    //MARK: updating take back count label
    private func updateTakebackCountLabel() {
        if let takebackCount = takebackCount{
            takebackCountLabel?.text = takebackCount.description
        }
    }
    
    private func updateIcon(){
        if let takebackIcon = takebackIcon{
            takebackCountLabel?.backgroundColor = UIColor(patternImage: takebackIcon)
        }
    }
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        takebackCountLabel.adjustsFontSizeToFitWidth = true
        takebackCountLabel.minimumScaleFactor = 0.2
        if let takebackCount = takebackCount{
            takebackCountLabel?.text = takebackCount.description
        }
        //Add the icon behind the take back count label
        updateIcon()
    }

    override func viewDidLayoutSubviews() {
        updateIcon()
    }
    

    

}
