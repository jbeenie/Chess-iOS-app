//
//  SaveGameAlert.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-04-14.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit


class SaveGameAlert{
    private struct Titles{
        static let save = "Save"
        static let saveAs = "Save as New Game"
        static let cancel = "Cancel"
    }
    
    private struct Alert{
        static let title = "Save Game"
        static let message = "Would you like to update the saved game with the current game state, or use the current game state to save a new game?"
        static let style = UIAlertControllerStyle.actionSheet
    }
    
    static func createWith(save saveAction:((UIAlertAction) -> Void)?, saveAs saveAsAction: ((UIAlertAction) -> Void)?)->UIAlertController {
        let alert = UIAlertController(
                                    title: Alert.title,
                                    message: Alert.message,
                                    preferredStyle: Alert.style)
        
        alert.addAction(UIAlertAction(title: Titles.saveAs, style: .default, handler: saveAsAction))
        alert.addAction(UIAlertAction(title: Titles.save, style: .destructive, handler: saveAction))
        alert.addAction(UIAlertAction(title: Titles.cancel, style: .cancel))
        return alert
    }
    
}
