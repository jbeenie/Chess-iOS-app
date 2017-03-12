//
//  ChessNotification.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-11.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class ChessNotification: UILabel {
    
    enum NotificationType{
        case Check
        case Draw
        case Win(ChessPieceColor)
    }
    
    //MARK: - Properties
    let type:NotificationType
    
    //String displayed by the notification
    private func setText(){
        let text:String
        switch type {
        case .Check:
            text = "Check!"
        case .Draw:
            text = "Draw!"
        case .Win(let winningColor):
            text = "Check Mate! \(winningColor) Wins!"
        }
        self.text = text
    }
    
    init(frame: CGRect, type:NotificationType) {
        self.type = type
        super.init(frame: frame)
        self.setText()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
