//
//  ThemeableFetchResultsTableViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-05-05.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit
import Themeable

class ThemeableFetchResultsTableViewController: FetchResultsTableViewController, Themeable {

    override func viewDidLoad() {
        super.viewDidLoad()
        // register the themeable items once all the view and subviews
        // have been loaded
        AppTheme.manager.register(themeable: self)    }
    
    public func apply(theme: AppTheme) {
        self.tableView.separatorColor = theme.seperatorColor
        self.tableView.backgroundColor = theme.lightBackgroundColor
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return AppTheme.manager.activeTheme.statusBarStyle
    }

}
