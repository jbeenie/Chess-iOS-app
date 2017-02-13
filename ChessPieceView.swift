//
//  ChessPiece.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-10.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class ChessPieceView: UIImageView {
    //Dictionary associating a chess piece icon to each chess piece based on type and color
    static let ChessPieceIcons: [ChessPieceIdentifier:UIImage] =
    [
        ChessPieceIdentifier(color: ChessPieceColor.White,type: ChessPieceType.Pawn): UIImage(named:"BlackPawn.png")!,
        ChessPieceIdentifier(color: ChessPieceColor.White,type: ChessPieceType.Rook): UIImage(named:"BlackRook.png")!,
        ChessPieceIdentifier(color: ChessPieceColor.White,type: ChessPieceType.Knight_L): UIImage(named:"BlackLeftKnight.png")!,
        ChessPieceIdentifier(color: ChessPieceColor.White,type: ChessPieceType.Knight_R): UIImage(named:"BlackRightKnight.png")!,
        ChessPieceIdentifier(color: ChessPieceColor.White,type: ChessPieceType.Bishop): UIImage(named:"BlackBishop.png")!,
        ChessPieceIdentifier(color: ChessPieceColor.White,type: ChessPieceType.Queen): UIImage(named:"BlackQueen.png")!,
        ChessPieceIdentifier(color: ChessPieceColor.White,type: ChessPieceType.King): UIImage(named:"BlackKing.png")!,
        
        ChessPieceIdentifier(color: ChessPieceColor.Black,type: ChessPieceType.Pawn): UIImage(named:"WhitePawn.png")!,
        ChessPieceIdentifier(color: ChessPieceColor.Black,type: ChessPieceType.Rook): UIImage(named:"WhiteRook.png")!,
        ChessPieceIdentifier(color: ChessPieceColor.Black,type: ChessPieceType.Knight_L): UIImage(named:"WhiteLeftKnight.png")!,
        ChessPieceIdentifier(color: ChessPieceColor.Black,type: ChessPieceType.Knight_R): UIImage(named:"WhiteRightKnight.png")!,
        ChessPieceIdentifier(color: ChessPieceColor.Black,type: ChessPieceType.Bishop): UIImage(named:"WhiteBishop.png")!,
        ChessPieceIdentifier(color: ChessPieceColor.Black,type: ChessPieceType.Queen): UIImage(named:"WhiteQueen.png")!,
        ChessPieceIdentifier(color: ChessPieceColor.Black,type: ChessPieceType.King): UIImage(named:"WhiteKing.png")!
    ]
    
    
    enum ChessPieceType: String {
        case Pawn = "Pawn",
             Rook = "Rook",
             Knight_L = "Knight_L",
             Knight_R = "Knight_R",
             Bishop = "Bishop",
             Queen = "Queen",
             King = "King"
    }
    enum ChessPieceColor: Character {
        case White = "W", Black = "B"
    }
    
    //struct used to uniquely identify a chess piece type and color
    struct ChessPieceIdentifier: Hashable{
        var color: ChessPieceColor
        var type: ChessPieceType
        
        var hashValue: Int {
            return color.hashValue ^ type.hashValue
        }
        
        static func == (lhs: ChessPieceIdentifier, rhs: ChessPieceIdentifier) -> Bool {
            return lhs.type == rhs.type && lhs.color == rhs.color
        }
        init(color: ChessPieceColor, type: ChessPieceType){
            self.color = color
            self.type = type
        }
        
    }
    
    var chessPieceIdentifier: ChessPieceIdentifier
    
    convenience init(color: ChessPieceColor, type: ChessPieceType) {
        self.init(frame: CGRect.zero, color: color, type: type)
    }
    
    
    init(frame: CGRect, color: ChessPieceColor, type: ChessPieceType) {
        self.chessPieceIdentifier = ChessPieceIdentifier(color: color, type: type)
        super.init(frame: frame)
        self.image = ChessPieceView.ChessPieceIcons[self.chessPieceIdentifier]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
