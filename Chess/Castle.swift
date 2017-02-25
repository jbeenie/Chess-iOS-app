//
//  Castle.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-25.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class Castle: Move{
    let side: Side
    let rook: Rook
    
    override var description: String{
        return "\(super.description), castling Side:\(side)"
    }
    
    init(startPosition:Position, endPosition:Position, pieceEaten:ChessPiece?=nil, firstTimePieceMoved:Bool, side:Side,rook:Rook){
        self.side = side
        self.rook = rook
        super.init(startPosition: startPosition, endPosition: endPosition, pieceEaten: pieceEaten, firstTimePieceMoved: firstTimePieceMoved)
    }
}
