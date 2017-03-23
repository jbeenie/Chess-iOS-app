//
//  ChessSettings
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-21.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class ChessSettings: ImmutableChessSettings {
    override subscript(key: Key) -> ChessSetting? {
        get{return settings[key]}
        set{settings[key] = newValue}
    }
    
    var settings:[Key:ChessSetting]=ChessSettings.loadSettings(){
        didSet{save()}
    }

    
    //MARK: - Save and load settings from user defaults
    private func save(){
        let defaults = UserDefaults.standard
        for (key,value) in settings{
            let pListRepresentation = value.propertyListRepresentation()
            let data = Archiver.archive(data: pListRepresentation)
            defaults.set(data, forKey: key.rawValue)
        }
    }
    
}
