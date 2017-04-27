//
//  MenuViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-15.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide the navigation bar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.hidesBarsOnTap = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    //MARK: - Status Bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

    @IBAction func backToMainMenu(sender: UIStoryboardSegue) {
        
    }
    

}
