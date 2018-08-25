//
//  ThemeableNavigationController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-05-05.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit
import Themeable

class ThemeableNavigationController: UINavigationController, Themeable {

    override func viewDidLoad() {
        super.viewDidLoad()
        // register the themeable items once all the view and subviews
        // have been loaded
        AppTheme.manager.register(themeable: self) 
    }

    
    public func apply(theme: AppTheme) {
        self.navigationBar.backgroundColor = theme.navigationBarBackgroundColor
        self.navigationBar.borderColor = theme.navigationBarBorderColor
        self.navigationBar.tintColor = theme.navigationBarTintColor
        self.navigationBar.barTintColor = theme.navigationBarBackgroundColor
        self.navigationBar.barStyle = theme.navigationBarBarStyle
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: theme.navigationBarTextColor]
        
    }

}
