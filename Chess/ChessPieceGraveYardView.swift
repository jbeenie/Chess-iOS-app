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
    let Color = UIColor.white
    let SelectedColor = UIColor.gray
    
    struct Ratios{
        static let GraveYardSlotsWidthToGraveYardWidth:CGFloat = 0.9
        static let spaceBetweenGraveYardSlotsToGraveYardSlotHeight:CGFloat = 0.75
    }
    
    //MARK: - Computed Variables
    private var graveYardSlotWidth:CGFloat{
        return (self.bounds.width * Ratios.GraveYardSlotsWidthToGraveYardWidth)
    }
    
    private var graveYardSlotHeight:CGFloat{
        return graveYardSlotWidth/CGFloat(slotsPerRow)
    }
    
    private var graveYardSlotSize:CGSize{
        return CGSize(width: graveYardSlotWidth, height: graveYardSlotHeight)
    }
    
    private var xOfGraveYardSlots:CGFloat{
        return (self.bounds.width - graveYardSlotWidth)/2
    }
    
    private var yOfPawnSlots:CGFloat{
        return (self.bounds.height - graveYardSlotHeight * (2 + Ratios.spaceBetweenGraveYardSlotsToGraveYardSlotHeight))/2
    }
    
    private var yOfNonPawnSlots:CGFloat{
        return yOfPawnSlots + graveYardSlotHeight * (1 + Ratios.spaceBetweenGraveYardSlotsToGraveYardSlotHeight)
    }
    
    //MARK: - SubViews
    
    private lazy var pawnSlots: ChessPieceGraveYardSlotsView = {
        let pawnSlotsFrame = CGRect(x: self.xOfGraveYardSlots, y: self.yOfPawnSlots, width: self.graveYardSlotWidth, height: self.graveYardSlotHeight)
        let pawnSlots = ChessPieceGraveYardSlotsView(frame: pawnSlotsFrame, numberOfSlots:self.slotsPerRow)
        self.addSubview(pawnSlots)
        return pawnSlots

    }()
    
    private lazy var nonPawnSlots: ChessPieceGraveYardSlotsView = {
        let nonPawnSlotsFrame = CGRect(x: self.xOfGraveYardSlots, y: self.yOfNonPawnSlots, width: self.graveYardSlotWidth, height: self.graveYardSlotHeight)
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

























