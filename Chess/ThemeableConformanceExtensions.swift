//
//  ThemeableConformanceExtensions.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-05-04.
//  Copyright © 2017 beenie.inc. All rights reserved.
//


import UIKit
import Themeable


//TODO: Turn these extension into base classes called ThemedTableViewController
//TODO: Mame all Tableview controllers inherit from ThemeTableViewControllers
//TODO: Overide apply method in ThemedTableViewController instances to customize static tableviewcells
//TODO: do the same for UINavigationController, UITableViewCell, UICollectionViewController

extension UITableViewController:Themeable{
    public func apply(theme: AppTheme) {
        self.tableView.separatorColor = theme.seperatorColor
        self.tableView.backgroundColor = theme.lightBackgroundColor
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return AppTheme.manager.activeTheme.statusBarStyle
    }
}

extension UITableViewCell:Themeable{
    public func apply(theme: AppTheme) {
        self.textLabel?.textColor = theme.tableViewCellTextColor
        self.backgroundColor = theme.tableViewCellBackgroundColor
    }
    
}

extension UINavigationController:Themeable{
    public func apply(theme: AppTheme) {
        self.navigationBar.backgroundColor = theme.navigationBarBackgroundColor
        self.navigationBar.borderColor = theme.navigationBarBorderColor
        self.navigationBar.tintColor = theme.navigationBarTintColor
        self.navigationBar.barTintColor = theme.navigationBarBackgroundColor
        self.navigationBar.barStyle = theme.navigationBarBarStyle
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: theme.navigationBarTextColor]

    }
}
