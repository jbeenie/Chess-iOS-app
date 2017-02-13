//
//  ViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-10.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var chessBoard: ChessBoardView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func setUpView(){
        let origin = CGPoint(x: 0, y:0)
        let frame = CGRect(origin: origin, size: view.bounds.size)
        chessBoard = ChessBoardView(frame: frame, colorOfWhiteSquares: UIColor.white, colorOfBlackSquares: UIColor.green)
        if let chessBoard = chessBoard{
            chessBoard.setUpChessBoard()
            view.addSubview(chessBoard)
            chessBoard[0,0].chessPiece = ChessPieceView(color:ChessPieceView.ChessPieceColor.White, type:ChessPieceView.ChessPieceType.Knight_L)
        }
        
        
//        chessBoardSquare?.chessPiece = ChessPiece(color:ChessPiece.ChessPieceColor.White, type:ChessPiece.ChessPieceType.Knight_L)
    }
    
    

    


}

