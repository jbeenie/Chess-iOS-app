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
    
    //MARK: Position Translation
    static func modelPosition(from viewPosition: ChessBoardView.Position)->Position{
        return Position(row: viewPosition.row, col: viewPosition.col)!
    }
    
    static func viewPosition(from modelPosition: Position)->ChessBoardView.Position{
        return ChessBoardView.Position(row: modelPosition.row, col: modelPosition.col)!
    }
    
    static func viewPosition(of chessPiece:ChessPiece?)->ChessBoardView.Position?{
        return  chessPiece != nil ? viewPosition(from: chessPiece!.position) : nil
    }
    
    //MARK: ChessPiece -> ChessPieceView Translation
    static func chessPieceView(from chessPiece:ChessPiece?)->ChessPieceView?{
        guard let chessPiece = chessPiece else{return nil}
        let viewPieceColor = viewChessPieceColor(from: chessPiece.color)
        let viewPieceType = chessPieceType(from: chessPiece.typeId)
        return ChessPieceView(color: viewPieceColor, type: viewPieceType!)
    }
    
    static func chessPieceViews(from chessPieces:[ChessPiece])->[ChessPieceView]{
        return chessPieces.map {return chessPieceView(from: $0)!}
    }
    
    //MARK: ChessPieceView -> ChessPiece
    static func chessPiece(from chessPieceView: ChessPieceView, with position:Position, on chessboard: ChessBoard)->ChessPiece{
        let pieceColor = chessPieceColor(from: chessPieceView.chessPieceIdentifier.color)
        let pieceType = chessPieceView.chessPieceIdentifier.type
        let chessPieceCreator = chessPieceCreators[pieceType]!
        return chessPieceCreator(pieceColor, position, chessboard)
    }
    
    private static let chessPieceCreators:[ChessPieceView.ChessPieceType:(ChessPieceColor,Position,ChessBoard)->ChessPiece] = [
        .Pawn: {(color,pos,board) in return Pawn(color:color, position:pos, chessBoard:board)},
        .Rook: {(color,pos,board) in return Rook(color:color, position:pos, chessBoard:board)},
        .Knight_L: {(color,pos,board) in return Knight(color:color, position:pos, chessBoard:board)},
        .Knight_R: {(color,pos,board) in return Knight(color:color, position:pos, chessBoard:board)},
        .Bishop: {(color,pos,board) in return Bishop(color:color, position:pos, chessBoard:board)},
        .Queen: {(color,pos,board) in return Queen(color:color, position:pos, chessBoard:board)},
        .King: {(color,pos,board) in return King(color:color, position:pos, chessBoard:board)}
    ]
    
    //MARK: ChessPieceColor Translation
    static func viewChessPieceColor(from chessPieceColor:ChessPieceColor)->ChessPieceView.ChessPieceColor{
        return ChessPieceView.ChessPieceColor(rawValue: chessPieceColor.rawValue)!
    }
    
    static func chessPieceColor(from viewChessPieceColor:ChessPieceView.ChessPieceColor)->ChessPieceColor{
        return ChessPieceColor(rawValue: viewChessPieceColor.rawValue)!
    }
    
    //MARK: ChessPieceType Translation
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
    
    //MARK: Move Translation
    
    static func chessBoardViewMove(from modelMove:Move)->ChessBoardView.Move{
        var rookStartPosition:ChessBoardView.Position?=nil
        var rookEndPosition:ChessBoardView.Position?=nil
        
        if let castle = modelMove as? Castle{
            rookStartPosition = viewPosition(from: castle.initialRookPosition)
            rookEndPosition = viewPosition(from: castle.finalRookPosition)
        }
        
        let pieceToPromoteTo = chessPieceView(from:modelMove.pieceToPromoteTo)
        var pieceToDemoteTo:ChessPieceView? = nil
        if pieceToPromoteTo != nil{
            pieceToDemoteTo = chessPieceView(from: modelMove.pieceMoved)
        }
        
        return ChessBoardView.Move(
                            startPosition: viewPosition(from: modelMove.startPosition),
                            endPosition: viewPosition(from:modelMove.endPosition),
                            pieceCaptured: chessPieceView(from: modelMove.pieceCaptured),
                            positionOfPieceToCapture: viewPosition(of: modelMove.pieceCaptured),
                            pieceToPromoteTo: pieceToPromoteTo,
                            pieceToDemoteTo: pieceToDemoteTo,
                            rookStartPosition: rookStartPosition,
                            rookEndPosition: rookEndPosition
            )
        
        
    }

}
