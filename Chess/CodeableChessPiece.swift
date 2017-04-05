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
    let chessBoard: ChessBoard
    
    //MARK: Initializers
    
    init(color:ChessPieceColor, initialPosition: Position, position: Position, chessBoard:ChessBoard, hasMoved: Bool=false){
        self.color = color
        self.initialPosition = initialPosition
        self.position = position
        self.chessBoard = chessBoard
        self.hasMoved = hasMoved
    }
    
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
    
    convenience init(chessPiece: ChessPiece, chessBoard:ChessBoard?=nil){
        self.init(color: chessPiece.color,
                  initialPosition: chessPiece.initialPosition,
                  position: chessPiece.position,
                  chessBoard: chessBoard ?? chessPiece.chessBoard,
                  hasMoved: chessPiece.hasMoved)
    }
    
    //MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        //FIXME: - Needs to be repointed to the right board
        aCoder.encode(color.rawValue, forKey: "color")
        //FIXME: Structs need to be converted to NSDictionaries
        aCoder.encode(initialPosition, forKey: "initialPosition")
        aCoder.encode(position, forKey: "position")
        aCoder.encode(hasMoved, forKey: "hasMoved")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let rawValue = aDecoder.decodeObject(forKey: "color") as? String,
            let color = ChessPieceColor(rawValue: rawValue),
            let initialPosition = aDecoder.decodeObject(forKey: "initialPosition") as? Position,
            let position = aDecoder.decodeObject(forKey: "position") as? Position
            else {return nil}
            let hasMoved = aDecoder.decodeBool(forKey: "hasMoved")
        self.init(color: color,
                  initialPosition: initialPosition,
                  position: position,
                  chessBoard: ChessBoard(),//FIXME: Need to give it the actual ChessBoard!!  
                  hasMoved: hasMoved)
    }
}
