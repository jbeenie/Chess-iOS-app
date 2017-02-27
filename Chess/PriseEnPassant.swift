//
//  PriseEnPassant.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-24.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class PriseEnPassant: Move {
    var pawnCaptured:ChessPiece{
        return self.pieceCaptured!
    }
}
