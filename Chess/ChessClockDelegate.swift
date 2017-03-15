//
//  ChessClockDelegate.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-14.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

protocol ChessClockDelegate {
    func timerUp(for color:ChessPieceColor)
}
