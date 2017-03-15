//
//  ChessNotification.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-11.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class ChessNotification: UILabel {
    
    let temporary:Bool
    
    init(frame: CGRect, temporary:Bool) {
        self.temporary = temporary
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
