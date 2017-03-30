//
//  SaveGameTableViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-30.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class SaveGameTableViewController: UITableViewController, UITextFieldDelegate {
    

    //MARK: -  Actions
    
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - Outlets
    
    @IBOutlet weak var whitePlayerTextField: UITextField!
    @IBOutlet weak var blackPlayerTextField: UITextField!
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        whitePlayerTextField.delegate = self
        blackPlayerTextField.delegate = self
        self.tableView.allowsSelection = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //make the keyboard show up for the user to input the white player string
        whitePlayerTextField.becomeFirstResponder()
    }
    
    

    //MARK: - UITextField Delegate
    
    //Hide keyboard when user presses return button on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
