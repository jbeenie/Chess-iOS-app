//
//  CodeableChessPiece.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-04-05.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class CodeableChessPiece:NSObject,NSCoding{
    
    //MARK: - Properties
    //MARK: Constants
    let color: ChessPieceColor
    //MARK: Variables
    let initialPosition: Position
    var position: Position
    var hasMoved: Bool
    var chessBoard: ChessBoard
    
    //MARK: Initializers
    
    init(color:ChessPieceColor, initialPosition: Position, position: Position, chessBoard:ChessBoard, hasMoved: Bool=false){
        self.color = color
        self.initialPosition = initialPosition
        self.position = position
        self.chessBoard = chessBoard
        self.hasMoved = hasMoved
    }
    
    //Used to create new chess pieces at the start of games
    convenience init(color: ChessPieceColor,
                     position:Position,
                     chessBoard:ChessBoard,
                     hasMoved:Bool = false){
        self.init(color: color,
                  initialPosition:position,
                  position: position,
                  chessBoard:chessBoard,
                  hasMoved: hasMoved)
    }
    
    //MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(color.rawValue, forKey: "color")
        aCoder.encode(initialPosition.propertyList(), forKey: "initialPosition")
        aCoder.encode(position.propertyList(), forKey: "position")
        aCoder.encode(hasMoved, forKey: "hasMoved")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let rawValue = aDecoder.decodeObject(forKey: "color") as? String,
            let color = ChessPieceColor(rawValue: rawValue),
            let initialPosition = Position(propertyList: aDecoder.decodeObject(forKey: "initialPosition")),
            let position = Position(propertyList:aDecoder.decodeObject(forKey: "position"))
            else {return nil}
            let hasMoved = aDecoder.decodeBool(forKey: "hasMoved")
        self.init(color: color,
                  initialPosition: initialPosition,
                  position: position,
                  chessBoard: ChessBoard(),  
                  hasMoved: hasMoved)
    }
}
