//
//  ChessPieceGraveYardViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-06.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class ChessPieceGraveYardViewController: UIViewController {
    struct Default{
        static let Color: ChessPieceColor = .White
    }
    
    struct Constants{
        static let MaxPiecesInRow = 8
    }
    
    
    //MARK: - Model
    var chessPieceGraveYard: ChessPieceGraveYard = ChessPieceGraveYard()
    
    //MARK: - Processing Model into View
    private var pawnsCaptured: [ChessPiece]{
        return chessPieceGraveYard.capturedChessPieces.filter { $0 is Pawn}
    }
    
    private var nonPawnsCaptured:[ChessPiece]{
        return chessPieceGraveYard.capturedChessPieces.filter { !($0 is Pawn)}
    }
    
    private func nonPawn(firstRow:Bool)->[ChessPiece]{
        if firstRow{
            return nonPawnsCaptured.enumerated().flatMap{ $0.offset < Constants.MaxPiecesInRow  ? $0.element : nil }
        }else{
            return nonPawnsCaptured.enumerated().flatMap{ $0.offset >= Constants.MaxPiecesInRow  ? $0.element : nil }
        }
    }
    
    
    //MARK: Updating Model
    
    func add(chessPieces:[ChessPiece])->Bool{
        for chessPiece in chessPieces{
            guard chessPieceGraveYard.add(chessPiece) else{return false}
        }
        updateUI()
        return true
    }
    
    func add(chessPiece:ChessPiece)->Bool{
        guard chessPieceGraveYard.add(chessPiece) else{return false}
        updateUI()
        return true
    }
    
    func remove(chessPiece:ChessPiece)->Bool{
        guard chessPieceGraveYard.remove(chessPiece) else{return false}
        updateUI()
        return true
    }
    
    //MARK: - Views
    @IBOutlet weak var pawnGraveYardRowView: ChessPieceGraveYardRowView!
    @IBOutlet weak var nonPawnGraveYardRowView1: ChessPieceGraveYardRowView!
    @IBOutlet weak var nonPawnGraveYardRowView2: ChessPieceGraveYardRowView!
    
//    //MARK: setting up and Updating View
//    private func setupView(){
//        view.addSubview(chessPieceGraveYardView)
//        //make the chessPieceGraveYardView take up the entire portion of its superView
//        chessPieceGraveYardView.frame = view.bounds
//    }
    
    private func updateUI(){
        pawnGraveYardRowView.update(with: ModelViewTranslation.chessPieceViews(from: pawnsCaptured))
        nonPawnGraveYardRowView1.update(with: ModelViewTranslation.chessPieceViews(from: nonPawn(firstRow: true)))
        nonPawnGraveYardRowView2.update(with: ModelViewTranslation.chessPieceViews(from: nonPawn(firstRow: false)))
    }
    
    
    //MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupView()
    }
    
//    override func viewDidLayoutSubviews() {
//        pawnGraveYardRowView.updateSlotFrames()
//        nonPawnGraveYardRowView1.updateSlotFrames()
//        nonPawnGraveYardRowView2.updateSlotFrames()
//    }
    
//    private func setupView(){
//        pawnGraveYardRowView.addSlotsAsSubviews()
//        nonPawnGraveYardRowView1.addSlotsAsSubviews()
//        nonPawnGraveYardRowView2.addSlotsAsSubviews()
//    }

}
