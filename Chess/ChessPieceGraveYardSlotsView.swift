//
//  ChessPieceGraveYardSlotsView.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-28.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class ChessPieceGraveYardSlotsView: UIView {
    
    //MARK: - Constants
    let numberOfSlots:Int
    let slotColor = UIColor.white
    let slotSelectedColor = UIColor.gray
    
    //MARK: - Variables
    //number indicating the index of the first unoccupied slot in the slot stack
    private var top:Int = 0
    
    //MARK: - SubViews
    
    private lazy var slots: [ChessBoardSquareView] = {
        return Array<ChessBoardSquareView>(count: self.numberOfSlots, elementCreator: self.createSlot())
    }()
    
    
    
    //MARK: - Computed Variables
    private var slotSideLength:CGFloat{
        return self.bounds.width/CGFloat(numberOfSlots)
    }
    private var slotSize:CGSize{
        return CGSize(width: slotSideLength, height: slotSideLength)
    }
    
    private var yOfSlot:CGFloat{
        return (self.bounds.height - slotSideLength)/2
    }
    
    
    //MARK: - Methods
    
    //Helper method used to Create slot subviews
    private func createSlot()->ChessBoardSquareView{
        return ChessBoardSquareView(frame: CGRect.zero, color: slotColor, selectedColor: slotSelectedColor)!
    }
    
    //sets the frames of the slots and
    //adds each slot as a subview
    func setUpSlots(){
        //setup pawn slots
        for (i,slot) in slots.enumerated(){
            let origin = CGPoint(x: CGFloat(i)*slotSideLength, y: yOfSlot)
            slot.frame = CGRect(origin: origin, size: slotSize)
            addSubview(slot)
        }
    }
    
    //Adding ChessPieces to slots
    func add(chessPieceView:ChessPieceView){
        let slotTobeFilled = nextEmptySlot()
        slotTobeFilled.chessPiece = chessPieceView
        top += 1
    }
    
    private func nextEmptySlot()->ChessBoardSquareView{
        return slots[top]
    }
    
    
    //MARK: - Initializers
    init(frame: CGRect, numberOfSlots: Int) {
        self.numberOfSlots = numberOfSlots
        super.init(frame: frame)
        self.setUpSlots()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
