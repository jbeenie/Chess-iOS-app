//
//  ChessPieceGraveYard.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-06.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class ChessPieceGraveYard{
    //MARK: Constants
    private let order = [Pawn.typeId:1,
                         Knight.typeId:2,
                         Bishop.typeId:3,
                         Rook.typeId:4,
                         Queen.typeId:5,
                         King.typeId:6]
    
    //MARK: - Stored Properties
    let color: ChessPieceColor
    private var capturedChessPieces:[ChessPiece] = [ChessPiece]()
    
    
    //MARK: - Computed Properties
    var description: String{
        var description = "Captured chess pieces:(\(color)):\n"
        for capturedChessPiece in capturedChessPieces{
            description += capturedChessPiece.description + ","
        }
        return description
    }
    
    //MARK: - Methods
    //MARK: Exposed

    func add(_ chessPiece: ChessPiece)->Bool{
        //first check that the piece being added is of the appropriate color
        guard chessPiece.color == self.color else{return false}
        //if it does add the chesspiece to the graveYard
        capturedChessPieces.append(chessPiece)
        //sort the pieces in the graveYard
        sort()
        return true
    }
    
    func remove(_ chessPieceToRemove:ChessPiece)->Bool{
        //search for the piece to remove in the captured pieces array
        for (index,capturedChessPiece) in capturedChessPieces.enumerated(){
            if capturedChessPiece.typeId == chessPieceToRemove.typeId{
                //if you find it remove and return true
                capturedChessPieces.remove(at: index)
                return true
            }
        }
        //if you dont find it return false
        return false
    }
    
    
    //MARK: Private
    private func sort(){
        capturedChessPieces.sort { (piece1, piece2) -> Bool in
            order[piece1.typeId]! < order[piece2.typeId]!
        }
    }
    
    //MARK: - Initializer
    init(color:ChessPieceColor) {
        self.color = color
    }
}
