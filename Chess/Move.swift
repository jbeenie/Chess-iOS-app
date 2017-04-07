//
//  Move.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-24.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class Move:NSObject,NSCoding{
    static let promotionRank = ChessBoard.Dimensions.SquaresPerColumn
    
    let startPosition: Position
    var endPosition: Position
    let pieceMoved: ChessPiece
    var pieceCaptured: ChessPiece?
    let firstTimePieceMoved: Bool
    var pieceToPromoteTo:ChessPiece?
    
    var promotionOccured: Bool{
        return (pieceMoved is Pawn && pieceMoved.rank(ifAt:endPosition) == Move.promotionRank)
    }
    
    func isPawnDoubleStep()->Bool{
        return  (pieceMoved is Pawn) && abs(startPosition.row - endPosition.row) == 2
    }
    
    
    override var description: String{
        return "\(startPosition.description) -> \(endPosition.description)\n" +
        "piece Moved: \(pieceMoved.description)\n" +
        "piece captured: \(pieceCaptured?.description ?? "none" )\n" +
        "first Time piece moved: \(firstTimePieceMoved)\n\n"
    }
    
    
    //MARK: Initializers
    init(startPosition:Position, endPosition:Position, pieceMoved:ChessPiece, pieceCaptured:ChessPiece?=nil, firstTimePieceMoved:Bool,pieceToPromoteTo:ChessPiece?=nil){
        self.startPosition = startPosition
        self.endPosition = endPosition
        self.pieceMoved = pieceMoved
        self.pieceCaptured = pieceCaptured
        self.firstTimePieceMoved = firstTimePieceMoved
        self.pieceToPromoteTo = pieceToPromoteTo
    }
    
    
    
    //MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.startPosition.propertyList(), forKey: "startPosition")
        aCoder.encode(self.endPosition.propertyList(), forKey: "endPosition")
        aCoder.encode(self.pieceMoved, forKey: "pieceMoved")
        aCoder.encode(self.firstTimePieceMoved, forKey: "firstTimePieceMoved")
        aCoder.encode(self.pieceToPromoteTo, forKey: "pieceToPromoteTo")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard
            let startPosition = Position(propertyList:aDecoder.decodeObject(forKey:"startPosition")),
            let endPosition = Position(propertyList:aDecoder.decodeObject(forKey:"endPosition")),
            let pieceMoved = aDecoder.decodeObject(forKey:"pieceMoved") as? ChessPiece
            else { return nil }
        
        let firstTimePieceMoved = aDecoder.decodeBool(forKey:"firstTimePieceMoved")
        let pieceToPromoteTo = aDecoder.decodeObject(forKey:"pieceToPromoteTo") as? ChessPiece
        
        self.init(startPosition: startPosition,
                  endPosition: endPosition,
                  pieceMoved: pieceMoved,
                  firstTimePieceMoved: firstTimePieceMoved,
                  pieceToPromoteTo:pieceToPromoteTo)
    }
}
