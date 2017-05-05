//
//  ThemeableTableViewCell.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-05-05.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit
import Themeable

class ThemeableTableViewCell: UITableViewCell, Themeable {

    override func awakeFromNib() {
        super.awakeFromNib()
        // register the themeable items once all the view and subviews
        // have been loaded
        AppTheme.manager.register(themeable: self)
    }
    
    public func apply(theme: AppTheme) {
        self.textLabel?.textColor = theme.tableViewCellTextColor
        self.backgroundColor = theme.tableViewCellBackgroundColor
    }

}
