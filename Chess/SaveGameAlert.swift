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
    
    private struct Content{
        static let title:String? = nil //"Save Game"
        static let message:String? = nil //"Would you like to update the saved game with the current game state, or use the current game state to save a new game?"
    }
    
    private struct Style{
        static let alert = UIAlertControllerStyle.actionSheet
        static let saveAs = UIAlertActionStyle.default
        static let save = UIAlertActionStyle.default
    }
    
    static func createWith(save saveAction:((UIAlertAction) -> Void)?, saveAs saveAsAction: ((UIAlertAction) -> Void)?)->UIAlertController {
        let alert = UIAlertController(
                                    title: Content.title,
                                    message: Content.message,
                                    preferredStyle: Style.alert)
        
        alert.addAction(UIAlertAction(title: Titles.saveAs, style: Style.saveAs, handler: saveAsAction))
        alert.addAction(UIAlertAction(title: Titles.save, style: Style.save, handler: saveAction))
        alert.addAction(UIAlertAction(title: Titles.cancel, style: .cancel))
        return alert
    }
    
}
