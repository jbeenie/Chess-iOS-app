//
//  PromotionDelegate.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-07.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

protocol PromotionDelegate{
    func getPieceToPromoteTo(ofColor color: ChessPieceColor, at position: Position, on board:ChessBoard)->ChessPiece
}
