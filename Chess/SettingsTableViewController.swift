//
//  SettingsTableViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-15.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    struct StoryBoard{
        static let MaxTakebacksSegue = "MaxTakebacks"
        static let TimeControlSegue = "TimeControl"
    }
    
    
    //MARK: - View Controller Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

   //MARK: - Actions
    
    @IBAction func chessNotificationsSwitchValueChanged(_ sender: UISwitch) {
    }

    @IBAction func animationsSwitchValueChanged(_ sender: UISwitch) {
    }
    
    @IBAction func chessClockSwitchValueChanged(_ sender: UISwitch) {
        sender.isOn ? enable(cell: timeControlCell) : disable(cell: timeControlCell)

    }

    @IBAction func takeBacksSwitchValueChanged(_ sender: UISwitch) {
        sender.isOn ? enable(cell: maxTakeBacksCell) : disable(cell: maxTakeBacksCell)
    }

   
    //MARK: - Outlets

    @IBOutlet weak var timeControlCell: UITableViewCell!
    
    @IBOutlet weak var maxTakeBacksCell: UITableViewCell!

    

    //MARK: - Enabling and Disabling Cell
    
    private func disable(cell:UITableViewCell){
        cell.isUserInteractionEnabled = false
        cell.textLabel!.isEnabled = false
        cell.detailTextLabel!.isEnabled = false
    }
    
    private func enable(cell:UITableViewCell){
        cell.isUserInteractionEnabled = true
        cell.textLabel!.isEnabled = true
        cell.detailTextLabel!.isEnabled = true
    }

    

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        if identifier == StoryBoard.MaxTakebacksSegue{
            //tell it the initial slider value
        }else if identifier == StoryBoard.TimeControlSegue{
            //tell it the initial slider value
        }
    }
    
    


}
