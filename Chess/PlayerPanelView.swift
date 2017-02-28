//
//  PlayerPanelView.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-27.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class PlayerPanelView: UIView {
    //MARK: - Position of Views
    lazy var divisionSize:CGSize = {
        let divisionWidth = self.bounds.width / 2
        return CGSize(width: divisionWidth, height: self.bounds.height)
    }()
    lazy var graveYardFrame:CGRect = CGRect(origin: self.bounds.origin, size: self.divisionSize)
    lazy var clockFrame: CGRect = CGRect(lowerRight: self.bounds.lowerRight, size: self.divisionSize)
    
    //MARK: - Properties
    let playerColor:ChessPieceColor
    
    //Subviews
    let graveYardView = ChessPieceGraveYardView()
    let clockView = UIView()
    
    private func setUpSubViews(){
        //GraveYardView
        graveYardView.frame = graveYardFrame
        graveYardView.backgroundColor = UIColor.blue
        graveYardView.setUpSubviews()
        self.addSubview(graveYardView)
        //ClockView
        clockView.frame = clockFrame
        clockView.backgroundColor = UIColor.red
        self.addSubview(clockView)

    }
   
    
    
    init(frame: CGRect, playerColor: ChessPieceColor){
        self.playerColor = playerColor
        super.init(frame: frame)
        setUpSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
