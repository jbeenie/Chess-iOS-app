//
//  AppTheme.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-05-04.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit
import Themeable

// Define the theme and its properties to be used throughout your app
public struct AppTheme: Theme {
    
    //MARK: Public
    public let identifier: String
    
    // Expose the available theme variants
    public static let variants: [AppTheme] = [ .dark ] //, .light]
    
    // Expose the shared theme managerb
    public static let manager = ThemeManager<AppTheme>(default: .dark)
    
    //MARK: - Custom Properties
    
    //MARK: Status Bar
    let statusBarStyle: UIStatusBarStyle
    
    //MARK: TableView
    let seperatorColor: UIColor
    let lightBackgroundColor: UIColor
    
    
    //MARK: TableViewCell
    let tableViewCellTextColor:UIColor
    let tableViewCellBackgroundColor:UIColor
    
    //MARK: NavigationBar
    let navigationBarBackgroundColor: UIColor
    let navigationBarBorderColor: UIColor
    let navigationBarTintColor: UIColor
    let navigationBarBarTintColor: UIColor
    let navigationBarBarStyle:UIBarStyle
    let navigationBarTextColor:UIColor
    
    
    //MARK: - Themes
    
//    static let light = MyAppTheme(
//        identifier: "chess.Themeable.light-theme",
//        seperatorColor: .lightGray,
//        lightBackgroundColor: .white,
//        statusBarStyle: .default,
//        tableViewCellTextColor: .black,
//        tableViewCellBackgroundColor: .white
//    )
    
    static let dark = AppTheme(
        identifier: "chess.Themeable.dark-theme",
        statusBarStyle: .lightContent,
        //TableView
        seperatorColor: AppColor.greenFromAppIcon,
        lightBackgroundColor: .black,
        //TableViewCell
        tableViewCellTextColor: AppColor.greenFromAppIcon,
        tableViewCellBackgroundColor: .darkGray,
        //NavigationBar
        navigationBarBackgroundColor: .black,
        navigationBarBorderColor: AppColor.greenFromAppIcon,
        navigationBarTintColor: AppColor.greenFromAppIcon,
        navigationBarBarTintColor: AppColor.greenFromAppIcon,
        navigationBarBarStyle: .black,
        navigationBarTextColor: .gray
    )
    
    
    
    
    
}
