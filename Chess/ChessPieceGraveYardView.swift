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
    static let numberOfPawnSlots = 8
    static let numberOfNonPawnSlots = 7
    
    struct Slot{
        static let Color = UIColor.white
        static let SelectedColor = UIColor.gray
    }
    
    struct Ratios{
        static let RowWidthToGraveYardViewWidth:CGFloat = 0.9
        static let spaceBetweenRowSlotsToSlotHeight:CGFloat = 0.25
    }
    
    //MARK: - Computed Variables
    private var slotSideLength:CGFloat{
        return (self.bounds.width * Ratios.RowWidthToGraveYardViewWidth)/CGFloat(ChessPieceGraveYardView.numberOfPawnSlots)
    }
    private var slotSize:CGSize{
        return CGSize(width: slotSideLength, height: slotSideLength)
    }
    
    private var xOfLeftMostSlot:CGFloat{
        return (self.bounds.width * (1-Ratios.RowWidthToGraveYardViewWidth))/2
    }
    
    private var yOfPawnSlot:CGFloat{
        return (self.bounds.height - slotSideLength * (2 + Ratios.spaceBetweenRowSlotsToSlotHeight))/2
    }
    
    private var yOfNonPawnSlot:CGFloat{
        return yOfPawnSlot + slotSideLength * (1 + Ratios.spaceBetweenRowSlotsToSlotHeight)
    }
    
    //MARK: - SubViews
    
    private lazy var pawnSlots: [ChessBoardSquareView] = {
        return Array<ChessBoardSquareView>(count: numberOfPawnSlots, elementCreator: self.createSlot())
    }()
    
    private lazy var nonPawnSlots: [ChessBoardSquareView] = {
        return Array<ChessBoardSquareView>(count: numberOfPawnSlots, elementCreator: self.createSlot())
    }()
    
    //Helper method used to Create slot subviews
    private func createSlot()->ChessBoardSquareView{
        return ChessBoardSquareView(frame: CGRect.zero, color: Slot.Color, selectedColor: Slot.SelectedColor)!
    }
    
    //set the frames of the subviews
    //add each slot as a subview
    func setUpSubviews(){
        //setup pawn slots
        for (i,pawnSlot) in pawnSlots.enumerated(){
            let origin = CGPoint(x: xOfLeftMostSlot+CGFloat(i)*slotSideLength, y: yOfPawnSlot)
            pawnSlot.frame = CGRect(origin: origin, size: slotSize)
            addSubview(pawnSlot)
        }
        //setup non pawn slots
        for (i,nonPawnSlot) in nonPawnSlots.enumerated(){
            let origin = CGPoint(x: xOfLeftMostSlot+CGFloat(i)*slotSideLength, y: yOfNonPawnSlot)
            nonPawnSlot.frame = CGRect(origin: origin, size: slotSize)
            addSubview(nonPawnSlot)
        }
    }
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

























