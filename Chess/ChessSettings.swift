//
//  ChessSettings
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-21.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class ChessSettings{
    
    //MARK: - Keys used to reference elements in settings
    enum Key:String{
        case chessBoardTheme = "chessBoardTheme"
        case notificationsEnabled = "notificationsEnabled"
        case animationsEnabled = "animationsEnabled"
    }
    
    //MARK: - Subscripts
    subscript(key: Key) -> ChessSetting? {
        get{return settings[key]}
        set{settings[key] = newValue}
    }
    //MARK: - Stored Properties
    
    //MARK: Current Settings
    var settings:[Key:ChessSetting]=ChessSettings.loadSettings(){
        didSet{save()}
    }
    
    //MARK: Defaults Settings
    static let defaultSettings:[Key:ChessSetting] = [
        Key.chessBoardTheme:ChessBoardThemes.GreenWhite,
        Key.notificationsEnabled:true,
        Key.animationsEnabled:true
    ]
    
    //MARK: - Mothed
    //MARK: returns PropertyList Representation of a dictionary of chessCettings
    static func pListRepresentation(ofSettings settings:[Key:ChessSetting])->[String:Any]{
        var pList: [String:Any] = [:]
        for (key,value) in settings{
            let encodableValue:Any
            switch key {
            case .animationsEnabled,.notificationsEnabled:
                encodableValue = value
            case .chessBoardTheme:
                encodableValue = (value as! ChessBoardTheme).propertyList()
            }
            pList[key.rawValue] = encodableValue
        }
        return pList
    }

    
    //MARK: - Save and load settings from user defaults
    
    //MARK: Save
    private func save(){
        let defaults = UserDefaults.standard
        defaults.setValuesForKeys(ChessSettings.pListRepresentation(ofSettings: settings))
        print(settings.description)
        print(UserDefaults.standard.dictionaryRepresentation())

    }
    
    //MARK: Load
    internal static func loadSettings()->[Key:ChessSetting]{
        let defaults = UserDefaults.standard
        var settings = [Key:ChessSetting]()
        for (key,_) in defaultSettings{
            switch key {
            case .animationsEnabled, .notificationsEnabled:
                settings[key] = defaults.bool(forKey: key.rawValue)
            case .chessBoardTheme:
                settings[key] = ChessBoardTheme(propertyList: defaults.object(forKey: key.rawValue))
            }
        }
        return settings
    }
    
    
    //MARK: - Debugging
    
    var description:String{
        return settings.debugDescription
    }
    
}
