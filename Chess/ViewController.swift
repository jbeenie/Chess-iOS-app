//
//  ViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-10.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var chessBoardSquare: ChessBoardSquare? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func setUpView(){
        let origin = CGPoint(x: 50, y:50)
        let size = CGSize(width: 50, height: 50)
        let frame = CGRect(origin: origin, size: size)
        chessBoardSquare = ChessBoardSquare(frame: frame, color: UIColor.gray)
        chessBoardSquare?.chessPiece = ChessPiece(color:ChessPiece.ChessPieceColor.White, type:ChessPiece.ChessPieceType.Knight_L)
        view.addSubview(chessBoardSquare!)
    }
    
    

    


}

