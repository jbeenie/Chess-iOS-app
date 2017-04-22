//
//  ChessPieceGraveYardRowView.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-06.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class ChessPieceGraveYardRowView: UIView {
    
    
    //MARK: - Constants
    @IBInspectable let numberOfSlots:Int = 8
    @IBInspectable let slotColor = UIColor.white
    @IBInspectable let slotSelectedColor = UIColor.gray
    
    
    //MARK: - SubViews
    
    private lazy var slots: [ChessBoardSquareView] = {
        return Array<ChessBoardSquareView>(count: self.numberOfSlots, elementCreator: self.createSlot())
    }()
    
    
    
    //MARK: - Computed Variables
    private var slotSideLength:CGFloat{
        print("slot side length: \(min(self.frame.width/CGFloat(numberOfSlots), self.frame.height)) ")
        return min(self.frame.width/CGFloat(numberOfSlots), self.frame.height)
    }
    private var slotSize:CGSize{
        return CGSize(width: slotSideLength, height: slotSideLength)
    }
    
    private var yOriginOfSlots:CGFloat{
        return (self.bounds.height - slotSideLength)/2
    }
    
    private var xOriginOfFirstSlot:CGFloat{
        return (self.bounds.width - slotSideLength*CGFloat(numberOfSlots))/2
    }
    
    //MARK: - View Life Cycle
    override func willMove(toSuperview newSuperview: UIView?) {
        addSlotsAsSubviews()
    }
    
    override func layoutSubviews() {
        updateSlotFrames()
    }
    
    //MARK: - Methods
    
    
    //Helper method used to Create slot subviews
    private func createSlot()->ChessBoardSquareView{
        return ChessBoardSquareView(frame: CGRect.zero, color: slotColor, selectedColor: slotSelectedColor)!
    }
    
    //MARK: Adding Slots to View Hierarchy

    private func addSlotsAsSubviews(){
        //setup pawn slots
        for slot in slots{addSubview(slot)}
    }
    
    //MARK: Resizing Slots
    //should be called when bounds change
    private func updateSlotFrames(){
        //store computed value of slot Side length in constant
        //so you do not get different values when recomputing
        let slotSideLength = self.slotSideLength
        //resize slots using new slot Side length
        for (i,slot) in slots.enumerated(){
            let x = xOriginOfFirstSlot + CGFloat(i)*slotSideLength
            let origin = CGPoint(x: x, y: yOriginOfSlots)
            slot.frame = CGRect(origin: origin, size: slotSize)
        }
        print("\n\n")
    }
    
    //updates the contents of the slots
    func update(with chessPieceViews:[ChessPieceView]){
        clear()
        for (i,chessPieceView) in chessPieceViews.enumerated(){
            slots[i].chessPiece = chessPieceView
        }
    }
    
    private func clear(){
        for slot in slots{
            slot.chessPiece = nil
        }
    }
    
    
}
