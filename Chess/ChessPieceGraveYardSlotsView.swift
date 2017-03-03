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
    
    //Adding and removing ChessPieces to slots
    func add(chessPieceView:ChessPieceView){
        let slotTobeFilled = nextEmptySlot()
        slotTobeFilled.chessPiece = chessPieceView
        top += 1
    }
    
    //returns true if piece was removed
    func remove(chessPieceView:ChessPieceView)->Bool{
        //find a slot containing an identical chessPieceView 
        //and empty it contents
        var pieceRemoved:Bool = false
        for i in 0..<numberOfSlots{
            if slots[i].chessPiece == chessPieceView{
                slots[i].chessPiece = nil
                pieceRemoved = true
            }
        }
        //if no piece was removed return
        guard pieceRemoved else {return false}
        top -= 1
        //otherwise shift remaining pieces over if necessary
        shift()
        return true
    }
    
    //shifts the chesspieces in the graveyardslots over to the left
    private func shift(){
        if top < 2 {return}
        for i in 0..<numberOfSlots-1 {
            if slots[i].chessPiece == nil{
                slots[i].chessPiece = slots[i+1].chessPiece
                slots[i+1].chessPiece = nil
            }
        }
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
