//
//  ChessBoardViewControllerDelegate.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-13.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

protocol ChessBoardViewControllerDelegate{
    var animate:Bool {get}
    
    func singleTapOccured(on tappedChessBoardSquare: ChessBoardSquareView)
    
    func doubleTapOccured()
    
}
