//
//  ChessPiece.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-15.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class ChessPiece{
    //MARK: -Properties
    let color: ChessPieceColor
    var description: String{
        return "\(color.rawValue)"
    }
    
    enum ChessPieceColor: Character {
        case White = "W", Black = "B"
        mutating func alternate() {
            switch self {
            case .White:
                self = .Black
            case .Black:
                self = .White
            }
        }
    }
    
    init(color: ChessPieceColor){
        self.color = color
    }
    
    
    
    
}
