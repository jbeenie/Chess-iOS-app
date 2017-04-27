//
//  ModelViewTranslation.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-06.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation
import AdvancedDataStructures


class ModelViewTranslation{
    
    //MARK:   Translation between Model and View
    
    //MARK: - Position
    
    static let positionMap = Mapping<ChessBoardView.Position,Position>(
        map: {Position(row: $0.row, col: $0.col)!},
        inverse: {ChessBoardView.Position(row: $0.row, col: $0.col)!}
    )
    
    //MARK: - ChessPieceColor
    
    static let chessPieceColorMap = Mapping<ChessPieceColor,ChessPieceView.ChessPieceColor>(
        map: {ChessPieceView.ChessPieceColor(rawValue: $0.rawValue)!},
        inverse: {ChessPieceColor(rawValue: $0.rawValue)!}
    )
    
    //MARK: - ChessPiece Type
    
    static var chessPieceTypeInjection:Injection<ChessPieceType,ChessPieceView.ChessPieceType>{
        return
            Injection<ChessPieceType,ChessPieceView.ChessPieceType>(pairs:
            [(.Pawn, ChessPieceView.ChessPieceType.Pawn),
             (.Rook, ChessPieceView.ChessPieceType.Rook),
             (.Knight, ChessPieceView.ChessPieceType.Knight_R),
             (.Bishop,ChessPieceView.ChessPieceType.Bishop),
             (.Queen,ChessPieceView.ChessPieceType.Queen),
             (.King,ChessPieceView.ChessPieceType.King)]
        )!
    }
    
    //MARK: ChessPiece -> viewPosition
    static func viewPosition(of chessPiece:ChessPiece?)->ChessBoardView.Position?{
        return  chessPiece != nil ? positionMap[chessPiece!.position] : nil
    }
    
    //MARK: [Poision:ChessPiece] -> [ChessBoardView.Position:ChessPieceView]
    
    static func viewChessPiecePositions(from modelChessPiecePositions:[Position:ChessPiece])->[ChessBoardView.Position:ChessPieceView]{
        return modelChessPiecePositions.mapPairs
            {(modelPos,chessPiece) in (positionMap[modelPos] , chessPieceView(from: chessPiece)!)}
    }
    
    //MARK: - ChessPiece -> ChessPieceView
    static func chessPieceView(from chessPiece:ChessPiece?)->ChessPieceView?{
        guard let chessPiece = chessPiece else{return nil}
        let viewPieceColor = chessPieceColorMap[chessPiece.color]
        guard let viewPieceType = chessPieceTypeInjection[chessPiece.typeId] else {return nil}
        return ChessPieceView(color: viewPieceColor, type: viewPieceType)
    }
    
    //MARK: [ChessPiece]->[ChessPieceView]
    static func chessPieceViews(from chessPieces:[ChessPiece])->[ChessPieceView]{
        return chessPieces.map {return chessPieceView(from: $0)!}
    }
    
    
    
    
    
    //MARK: - Move -> ChessBoardView.Move
    
    static func chessBoardViewMove(from modelMove:Move)->ChessBoardView.Move{
        var rookStartPosition:ChessBoardView.Position?=nil
        var rookEndPosition:ChessBoardView.Position?=nil
        
        if let castle = modelMove as? Castle{
            rookStartPosition = positionMap[castle.initialRookPosition]
            rookEndPosition = positionMap[castle.finalRookPosition]
        }
        
        let pieceToPromoteTo = chessPieceView(from:modelMove.pieceToPromoteTo)
        var pieceToDemoteTo:ChessPieceView? = nil
        if pieceToPromoteTo != nil{
            pieceToDemoteTo = chessPieceView(from: modelMove.pieceMoved)
        }
        
        return ChessBoardView.Move(
                            startPosition: positionMap[modelMove.startPosition],
                            endPosition: positionMap[modelMove.endPosition],
                            pieceCaptured: chessPieceView(from: modelMove.pieceCaptured),
                            positionOfPieceToCapture: viewPosition(of: modelMove.pieceCaptured),
                            pieceToPromoteTo: pieceToPromoteTo,
                            pieceToDemoteTo: pieceToDemoteTo,
                            rookStartPosition: rookStartPosition,
                            rookEndPosition: rookEndPosition
            )
        
        
    }

}
