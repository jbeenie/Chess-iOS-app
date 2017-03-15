//
//  ChessNotification.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-11.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class ChessNotification: UILabel {
    
    struct Constants{
        static let alignment = NSTextAlignment.center
        static let fontSize:CGFloat = 30
        static let font = UIFont.boldSystemFont(ofSize: fontSize)
    }
    
    
    let temporary:Bool
    
    init(frame: CGRect, temporary:Bool) {
        self.temporary = temporary
        super.init(frame: frame)
        self.textAlignment = Constants.alignment
        self.font = Constants.font
        self.numberOfLines = 0
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
