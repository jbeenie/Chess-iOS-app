//
//  ChessPieceGraveYardView.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-27.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class ChessPieceGraveYardView: UIView {
    //MARK: - Constants
    let slotsPerRow = 8
    let numberOfRows = 2
    let Color = UIColor.white
    let SelectedColor = UIColor.gray
    
    struct Ratios{
        static let rowWidthToTotalWidth:CGFloat = 0.9
        static let spaceBetweenRowsToRowHeight:CGFloat = 0.75
    }
    
    //MARK: - Computed Variables
    private var rowWidth:CGFloat{
        return (self.bounds.width * Ratios.rowWidthToTotalWidth)
    }
    
    private var rowHeight:CGFloat{
        return rowWidth/CGFloat(slotsPerRow)
    }
    
    private var rowSize:CGSize{
        return CGSize(width: rowWidth, height: rowHeight)
    }
    
    private var xOriginOfRows:CGFloat{
        return (self.bounds.width - rowWidth)/2
    }
    
    private var yOfPawnSlots:CGFloat{
        return (self.bounds.height - rowHeight * (2 + Ratios.spaceBetweenRowsToRowHeight))/2
    }
    
    private var yOfNonPawnSlots:CGFloat{
        return yOfPawnSlots + rowHeight * (1 + Ratios.spaceBetweenRowsToRowHeight)
    }
    
    //MARK: - SubViews
    
    private lazy var pawnSlots: ChessPieceGraveYardSlotsView = {
        let pawnSlotsFrame = CGRect(x: self.xOriginOfRows, y: self.yOfPawnSlots, width: self.rowWidth, height: self.rowHeight)
        let pawnSlots = ChessPieceGraveYardSlotsView(frame: pawnSlotsFrame, numberOfSlots:self.slotsPerRow)
        self.addSubview(pawnSlots)
        return pawnSlots

    }()
    
    private lazy var nonPawnSlots: ChessPieceGraveYardSlotsView = {
        let nonPawnSlotsFrame = CGRect(x: self.xOriginOfRows, y: self.yOfNonPawnSlots, width: self.rowWidth, height: self.rowHeight)
        let nonPawnSlots = ChessPieceGraveYardSlotsView(frame: nonPawnSlotsFrame, numberOfSlots:self.slotsPerRow)
        self.addSubview(nonPawnSlots)
        return nonPawnSlots
    }()
    
    //MARK: - Methods
    
    //Adding ChessPieces to graveYard
    func add(chessPieceView:ChessPieceView){
        //get the appropriate set of slots to add the piece to
        let slotToAddTo = getSlot(for: chessPieceView)
        //create a copy of the chessPieceView 
        let chessPieceViewCopy = ChessPieceView(chessPieceView: chessPieceView)
        //add the piece to the slots
        slotToAddTo.add(chessPieceView: chessPieceViewCopy)
    }
    
    func remove(chessPieceView:ChessPieceView)->Bool{
        let slotToRemoveFrom = getSlot(for: chessPieceView)
        return slotToRemoveFrom.remove(chessPieceView)
    }
    
    //MARK: Helper methods
    private func getSlot(for chessPieceView:ChessPieceView)->ChessPieceGraveYardSlotsView{
        return chessPieceView.chessPieceIdentifier.type == ChessPieceView.ChessPieceType.Pawn ? pawnSlots : nonPawnSlots
    }
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

























