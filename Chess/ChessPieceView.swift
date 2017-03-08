//
//  ChessPiece.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-10.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit
@IBDesignable
class ChessPieceView: UIImageView {

    //MARK: - Nested Types
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
    struct ChessPieceIdentifier: Hashable,Equatable{
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
    
    //MARK: - Properties
    var aspectRatio: CGFloat! = nil
    var chessPieceIdentifier: ChessPieceIdentifier
    override var description: String{
        return "\(chessPieceIdentifier.color) \(chessPieceIdentifier.type)"
    }
    lazy var aninmationCopy:ChessPieceView = {
        //create the animation copy
        let animationCopy = ChessPieceView(chessPieceView:self as ChessPieceView)
        //hide it
        //animationCopy.isHidden = true
        //add it as a subview of the animated chess board view
        (self.superview as? AnimatedChessBoardView)?.addSubview(animationCopy)
        animationCopy.frame = self.frame

        return animationCopy
        }()
    
    
    //MARK:  - Initializers

    
    convenience init(chessPieceView:ChessPieceView){
        self.init(frame: chessPieceView.frame, color: chessPieceView.chessPieceIdentifier.color, type: chessPieceView.chessPieceIdentifier.type)
    }
    
    convenience init(color: ChessPieceColor, type: ChessPieceType) {
        self.init(frame: CGRect.zero, color: color, type: type)
    }
    
    init(frame: CGRect, color: ChessPieceColor, type: ChessPieceType) {
        self.chessPieceIdentifier = ChessPieceIdentifier(color: color, type: type)
        super.init(frame: frame)
        self.image = ChessPieceView.ChessPieceIcons[self.chessPieceIdentifier]
        self.sizeToFit()
        self.aspectRatio = bounds.width / bounds.height
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Conforming to Equatable
    
    static func == (lhs: ChessPieceView, rhs: ChessPieceView) -> Bool {
        return lhs.chessPieceIdentifier == rhs.chessPieceIdentifier
    }
    
    //MARK: - Icons
    
    //Dictionary associating a chess piece icon to each chess piece based on type and color
    static let ChessPieceIcons: [ChessPieceIdentifier:UIImage] =
        [
            ChessPieceIdentifier(color: ChessPieceColor.Black,type: ChessPieceType.Pawn): UIImage(named:"blackPawn.png")!,
            ChessPieceIdentifier(color: ChessPieceColor.Black,type: ChessPieceType.Rook): UIImage(named:"blackRook.png")!,
            ChessPieceIdentifier(color: ChessPieceColor.Black,type: ChessPieceType.Knight_L): UIImage(named:"blackLeftKnight.png")!,
            ChessPieceIdentifier(color: ChessPieceColor.Black,type: ChessPieceType.Knight_R): UIImage(named:"blackRightKnight.png")!,
            ChessPieceIdentifier(color: ChessPieceColor.Black,type: ChessPieceType.Bishop): UIImage(named:"blackBishop.png")!,
            ChessPieceIdentifier(color: ChessPieceColor.Black,type: ChessPieceType.Queen): UIImage(named:"blackQueen.png")!,
            ChessPieceIdentifier(color: ChessPieceColor.Black,type: ChessPieceType.King): UIImage(named:"blackKing.png")!,
            
            ChessPieceIdentifier(color: ChessPieceColor.White,type: ChessPieceType.Pawn): UIImage(named:"whitePawn.png")!,
            ChessPieceIdentifier(color: ChessPieceColor.White,type: ChessPieceType.Rook): UIImage(named:"whiteRook.png")!,
            ChessPieceIdentifier(color: ChessPieceColor.White,type: ChessPieceType.Knight_L): UIImage(named:"whiteLeftKnight.png")!,
            ChessPieceIdentifier(color: ChessPieceColor.White,type: ChessPieceType.Knight_R): UIImage(named:"whiteRightKnight.png")!,
            ChessPieceIdentifier(color: ChessPieceColor.White,type: ChessPieceType.Bishop): UIImage(named:"whiteBishop.png")!,
            ChessPieceIdentifier(color: ChessPieceColor.White,type: ChessPieceType.Queen): UIImage(named:"whiteQueen.png")!,
            ChessPieceIdentifier(color: ChessPieceColor.White,type: ChessPieceType.King): UIImage(named:"whiteKing.png")!
    ]
    
    
}
