//
//  PromotionChoicesViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-09.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class PromotionChoicesViewController: UIViewController {
    //MARK: - Properties
    let color: ChessPieceColor
    let buttonBackGroundColor: UIColor
    let popOverBackGroundColor: UIColor
    let cornerRadius:CGFloat
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: Outlets
    @IBOutlet weak var knightUIButton: UIButton!
    @IBOutlet weak var bishopUIButton: UIButton!
    @IBOutlet weak var rookUIButton: UIButton!
    @IBOutlet weak var queenUIButton: UIButton!
    
    //MARK: Actions
    
    @IBAction func chosePieceToPromoteTo(_ sender: UIButton) {
    }
    
}
