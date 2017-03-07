//
//  BlackChessPieceGraveYardViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-06.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class BlackChessPieceGraveYardViewController: ChessPieceGraveYardViewController {
    //MARK: - Constants
    let color: ChessPieceColor = .White
    
    
    
    override func viewDidLoad() {
        chessPieceGraveYard.color = color
        super.viewDidLoad()
    }

}
