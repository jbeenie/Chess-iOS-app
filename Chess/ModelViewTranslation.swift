//
//  ModelViewTranslation.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-06.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class ModelViewTranslation{
    
    //MARK: -  Translation between Model and View
    static func modelPosition(from viewPosition: ChessBoardView.Position)->Position{
        return Position(row: viewPosition.row, col: viewPosition.col)!
    }
    
    static func viewPosition(from modelPosition: Position)->ChessBoardView.Position{
        return ChessBoardView.Position(row: modelPosition.row, col: modelPosition.col)!
    }
    
    static func viewPosition(of chessPiece:ChessPiece?)->ChessBoardView.Position?{
        return  chessPiece != nil ? viewPosition(from: chessPiece!.position) : nil
    }
    
    static func chessPieceView(from chessPiece:ChessPiece?)->ChessPieceView?{
        guard let chessPiece = chessPiece else{return nil}
        let viewPieceColor = viewChessPieceColor(from: chessPiece.color)
        let viewPieceType = chessPieceType(from: chessPiece.typeId)
        return ChessPieceView(color: viewPieceColor, type: viewPieceType!)
    }
    
    static func chessPieceViews(from chessPieces:[ChessPiece])->[ChessPieceView]{
        return chessPieces.map {return chessPieceView(from: $0)!}
    }
    
    static func viewChessPieceColor(from chessPieceColor:ChessPieceColor)->ChessPieceView.ChessPieceColor{
        return ChessPieceView.ChessPieceColor(rawValue: chessPieceColor.rawValue)!
    }
    
    static func chessPieceType(from chessPieceTypeId:String)->ChessPieceView.ChessPieceType?{
        switch chessPieceTypeId {
        case "P":
            return ChessPieceView.ChessPieceType.Pawn
        case "R":
            return ChessPieceView.ChessPieceType.Rook
        case "H":
            return ChessPieceView.ChessPieceType.Knight_R
        case "B":
            return ChessPieceView.ChessPieceType.Bishop
        case "Q":
            return ChessPieceView.ChessPieceType.Queen
        case "K":
            return ChessPieceView.ChessPieceType.King
        default:
            return nil
        }
    }

}
