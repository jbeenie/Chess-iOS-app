//
//  ThemeableSlider.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-05-05.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit
import Themeable
class ThemeableSlider: UISlider,Themeable {

    override func awakeFromNib() {
        super.awakeFromNib()
        // register the themeable items once all the view and subviews
        // have been loaded
        AppTheme.manager.register(themeable: self)
    }
    
    public func apply(theme: AppTheme) {
        self.thumbTintColor = theme.sliderThumbTintColor
        self.maximumTrackTintColor = theme.sliderMaximumTrackTintColor
        self.minimumTrackTintColor = theme.sliderMinimumTrackTintColor
        self.tintColor = theme.sliderTintColor
        self.borderColor = theme.sliderBorderColor
        self.backgroundColor = theme.sliderBackgroundColor
    }

}
