//
//  NavigationController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-05-04.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // register the themeable items once all the view and subviews
        // have been loaded
        AppTheme.manager.register(themeable: self)    }

}
