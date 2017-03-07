//
//  WhiteChessPieceGraveYardViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-06.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class WhiteChessPieceGraveYardViewController: ChessPieceGraveYardViewController {
    //MARK: - Constants
    let color: ChessPieceColor = .Black
    
    //MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        chessPieceGraveYard.color = color
        super.viewDidLoad()
    }

   

}
