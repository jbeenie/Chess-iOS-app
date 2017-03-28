//
//  ImmutableChessSettings.Swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-20.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class ImmutableChessSettings{
    
    
    //MARK: - Keys used to reference elements in settings
    enum Key:String{
        case chessBoardTheme = "chessBoardTheme"
        case notificationsEnabled = "notificationsEnabled"
        case animationsEnabled = "animationsEnable"
    }
    
    //MARK: - Defaults Settings
    private static let defaultSettings:[Key:ChessSetting] = [
        Key.chessBoardTheme:ChessBoardThemes.GreenWhite,
        Key.notificationsEnabled:true,
        Key.animationsEnabled:true
    ]
    
    //MARK: Current Settings
    private let settings:[Key:ChessSetting] = ChessSettings.loadSettings()
    
    //MARK: - Subscript for accessing internal settings data structure
    subscript(key: Key) -> ChessSetting? {
        get{return settings[key]}
    }
    
    //MARK: - Load Settings from User defaults
    internal static func loadSettings()->[Key:ChessSetting]{
        let defaults = UserDefaults.standard
        var settings = [Key:ChessSetting]()
        for (key,defaultValue) in defaultSettings{
            if let data = defaults.object(forKey: key.rawValue),
                let pListRepresentation = Archiver.unArchive(data: data),
                let value = unpack(propertyListRepresentation: pListRepresentation, with:key) {
                    settings[key] = value
            }else{
                settings[key] = defaultValue
            }
        }
        return settings
    }
    
    //MARK: - Unpack PropertyListRepresentation into original object
    private static func unpack(propertyListRepresentation: NSDictionary, with key:ChessSettings.Key)->ChessSetting?{
        switch key {
        case .animationsEnabled,.notificationsEnabled:
            return Bool(propertyListRepresentation: propertyListRepresentation)
        case .chessBoardTheme:
            return ChessBoardTheme(propertyListRepresentation: propertyListRepresentation)
        }
    }
    
    
    //MARK: - Debugging
    
    var description:String{
        return settings.debugDescription
    }
    
    
}
