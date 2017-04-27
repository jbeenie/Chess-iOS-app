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
        let chessPieceTypeInjection =
            Injection<ChessPieceType,ChessPieceView.ChessPieceType>(pairs:
            [(.Pawn, ChessPieceView.ChessPieceType.Pawn),
             (.Rook, ChessPieceView.ChessPieceType.Rook),
             (.Knight, ChessPieceView.ChessPieceType.Knight_R),
             (.Bishop,ChessPieceView.ChessPieceType.Bishop),
             (.Queen,ChessPieceView.ChessPieceType.Queen),
             (.King,ChessPieceView.ChessPieceType.King)]
        )!
        return chessPieceTypeInjection
    }
    
    //MARK: ChessPiece -> viewPosition
    static func viewPosition(of chessPiece:ChessPiece?)->ChessBoardView.Position?{
        return  chessPiece != nil ? positionMap[chessPiece!.position] : nil
    }
    
    //MARK: [Poision:ChessPiece] -> [ChessBoardView.Position:ChessPieceView]
    
    static func viewChessPiecePositions(from modelChessPiecePositions:[Position:ChessPiece])->[ChessBoardView.Position:ChessPieceView]{
        return modelChessPiecePositions.mapPairs
            {(modelPos,chessPiece) in (positionMap[modelPos] , chessPieceView(from: chessPiece, on: nil)!)}
    }
    
    //MARK: - ChessPiece -> ChessPieceView
    static func chessPieceView(from chessPiece:ChessPiece?, on chessBoardView:AnimatedChessBoardView?)->ChessPieceView?{
        guard let chessPiece = chessPiece else{return nil}
        let viewPieceColor = chessPieceColorMap[chessPiece.color]
        guard let viewPieceType = chessPieceTypeInjection[chessPiece.typeId] else {return nil}
        let chessPieceView =  ChessPieceView(color: viewPieceColor, type: viewPieceType)
        //resize and position newly created chesspiece views on chessboardview if possible
        chessBoardView?.resize(chessPieceView: chessPieceView, at: positionMap[chessPiece.position])
        return chessPieceView

    }
    
    //MARK: [ChessPiece]->[ChessPieceView]
    static func chessPieceViews(from chessPieces:[ChessPiece])->[ChessPieceView]{
        return chessPieces.map {return chessPieceView(from: $0, on: nil)!}
    }
    
    
    
    
    //MARK: - Move -> ChessBoardView.Move
    
    static func chessBoardViewMove(from modelMove:Move, for chessBoardView:AnimatedChessBoardView)->ChessBoardView.Move{
        let startPosition = positionMap[modelMove.startPosition]
        let endPosition = positionMap[modelMove.endPosition]
        let pieceCaptured = chessPieceView(from: modelMove.pieceCaptured, on: chessBoardView)
        let positionOfPieceToCapture = viewPosition(of: modelMove.pieceCaptured)
        let pieceToPromoteTo = chessPieceView(from:modelMove.pieceToPromoteTo, on: chessBoardView)
        
        var pieceToDemoteTo:ChessPieceView? = nil
        if pieceToPromoteTo != nil{
            pieceToDemoteTo = chessPieceView(from: modelMove.pieceMoved, on: chessBoardView)
        }
        
        var rookStartPosition:ChessBoardView.Position?=nil
        var rookEndPosition:ChessBoardView.Position?=nil
        if let castle = modelMove as? Castle{
            rookStartPosition = positionMap[castle.initialRookPosition]
            rookEndPosition = positionMap[castle.finalRookPosition]
        }
        
        return ChessBoardView.Move(
            startPosition: startPosition,
            endPosition: endPosition,
            pieceCaptured: pieceCaptured,
            positionOfPieceToCapture: positionOfPieceToCapture,
            pieceToPromoteTo: pieceToPromoteTo,
            pieceToDemoteTo: pieceToDemoteTo,
            rookStartPosition: rookStartPosition,
            rookEndPosition: rookEndPosition)
    }

}
