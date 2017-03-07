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
        return min(self.bounds.width/CGFloat(numberOfSlots), self.bounds.height)
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
            let x = xOriginOfFirstSlot + CGFloat(i)*slotSideLength
            let origin = CGPoint(x: x, y: yOriginOfSlots)
            slot.frame = CGRect(origin: origin, size: slotSize)
            addSubview(slot)
        }
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
