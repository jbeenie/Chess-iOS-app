//
//  SavedGameCell.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-30.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class SavedGameCell: ThemeableTableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var gameNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func apply(theme: AppTheme) {
        super.apply(theme: theme)
        self.gameNumberLabel.textColor = theme.tableViewCellLeftTextColor
        self.dateLabel.textColor = theme.tableViewCellRightTextColor
        self.timeLabel.textColor = theme.tableViewCellRightTextColor
    }

}
