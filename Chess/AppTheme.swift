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
    
    //MARK: CollectionView
    let collectionViewBackgroundColor: UIColor
    let collectionViewBorderColor: UIColor
    let collectionViewTintColor: UIColor
    
    //MARK: TableViewCell
    let tableViewCellLeftTextColor:UIColor
    let tableViewCellRightTextColor:UIColor
    let tableViewCellBackgroundColor:UIColor
    
    //MARK: CollecitonViewCell
    let collectionViewCellTintColor: UIColor
    let collectionViewCellborderColor: UIColor
    let collectionViewCellBackgroundColor: UIColor
    let collectionViewCellSelectedBackgroundColor: UIColor
    
    //MARK: NavigationBar
    let navigationBarBackgroundColor: UIColor
    let navigationBarBorderColor: UIColor
    let navigationBarTintColor: UIColor
    let navigationBarBarTintColor: UIColor
    let navigationBarBarStyle:UIBarStyle
    let navigationBarTextColor:UIColor
    
    //MARK: Switch
    let sliderThumbTintColor: UIColor
    let sliderMaximumTrackTintColor: UIColor
    let sliderMinimumTrackTintColor: UIColor
    let sliderTintColor: UIColor
    let sliderBorderColor: UIColor
    let sliderBackgroundColor: UIColor
    
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
        //CollectionView
        collectionViewBackgroundColor: .darkGray,
        collectionViewBorderColor: .white,
        collectionViewTintColor: .white,
        //TableViewCell
        tableViewCellLeftTextColor: AppColor.greenFromAppIcon,
        tableViewCellRightTextColor: .lightGray,
        tableViewCellBackgroundColor: .darkGray,
        //CollecitonViewCell
        collectionViewCellTintColor: .purple,
        collectionViewCellborderColor: .purple,
        collectionViewCellBackgroundColor: .purple,
        collectionViewCellSelectedBackgroundColor: AppColor.greenFromAppIcon,
        //NavigationBar
        navigationBarBackgroundColor: .black,
        navigationBarBorderColor: AppColor.greenFromAppIcon,
        navigationBarTintColor: AppColor.greenFromAppIcon,
        navigationBarBarTintColor: AppColor.greenFromAppIcon,
        navigationBarBarStyle: .black,
        navigationBarTextColor: .gray,
        //Switch
        sliderThumbTintColor: .gray,
        sliderMaximumTrackTintColor: .lightGray,
        sliderMinimumTrackTintColor: AppColor.greenFromAppIcon,
        sliderTintColor: .clear,
        sliderBorderColor: AppColor.greenFromAppIcon,
        sliderBackgroundColor: .clear
        
    )
    
    
    
    
    
}
