//
//  ThemeableCollectionViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-05-05.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit
import Themeable

class ThemeableCollectionViewController: UICollectionViewController, Themeable {

    override func viewDidLoad() {
        super.viewDidLoad()
        // register the themeable items once all the view and subviews
        // have been loaded
        AppTheme.manager.register(themeable: self)
    }
    
    public func apply(theme: AppTheme) {
        self.collectionView?.backgroundColor = theme.collectionViewBackgroundColor
        self.collectionView?.borderColor = theme.collectionViewBorderColor
        self.collectionView?.tintColor = theme.collectionViewTintColor
        
    }

  

}
