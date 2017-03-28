//
//  ChessGameSettings.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-20.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class ChessGameSettings:PropertyListCompatible{
    struct Constants{
        static let userDefaultsKey = "LatestGameSettings"
    }
    
    struct Default{
        static let maxTakebacks:TakebackCount = TakebackCount.Finite(1)
        static let clockTime:Int = 5 * 60 // 5 minutes
    }
    
    static let defaultGameSettings = ChessGameSettings(maxTakebacks: Default.maxTakebacks, clockTime: Default.clockTime)
    
    var maxTakebacks:TakebackCount
    var clockTime:Int?
    
    var animationsEnabled:Bool{
        return globalSettings[ChessSettings.Key.animationsEnabled] as! Bool
    }
    var notificationsEnabled:Bool{
        return globalSettings[ChessSettings.Key.notificationsEnabled] as! Bool
    }
    var chessBoardTheme:ChessBoardTheme{
        return globalSettings[ChessSettings.Key.chessBoardTheme] as! ChessBoardTheme
    }
    
    //up to date global settings
    var globalSettings:ImmutableChessSettings = ImmutableChessSettings()
    
    init(maxTakebacks:TakebackCount,
         clockTime:Int?){
        self.maxTakebacks = maxTakebacks
        self.clockTime = clockTime
    }
    
    
    //MARK: Save & Load game settings to and from user defaults
    internal func save(){
        let defaults = UserDefaults.standard
        let data = Archiver.archive(data: self.propertyListRepresentation())
        defaults.set(data, forKey: Constants.userDefaultsKey)
    }
    
    internal static func loadGameSettings()->ChessGameSettings{
        let defaults = UserDefaults.standard
        if let data = defaults.object(forKey: Constants.userDefaultsKey){
            let pListRepresentation = Archiver.unArchive(data: data)
            if let gameSettings = ChessGameSettings(propertyListRepresentation: pListRepresentation){
                return gameSettings
            }
        }
        return defaultGameSettings
    }
    
    
    //MARK: - Conforming to ChessSetting
    func propertyListRepresentation() -> NSDictionary {
        let representation:[String:AnyObject] = [
            "maxTakebacks":maxTakebacks.description as AnyObject,
            "clockTime":(clockTime?.description  ?? "nil") as AnyObject]
        return representation as NSDictionary
    }
    
    required convenience init?(propertyListRepresentation:NSDictionary?) {
        guard let values = propertyListRepresentation else {return nil}
        if let maxTakebacksString = values["maxTakebacks"] as? String,
            let clockTimeString = values["clockTime"] as? String{
            let maxTakebacks = maxTakebacksString == "∞" ? TakebackCount.Infinite : TakebackCount.Finite(Int(maxTakebacksString)!)
            let clockTime = clockTimeString == "nil" ? nil : Int(clockTimeString)!
            self.init(maxTakebacks:maxTakebacks,clockTime:clockTime)
        } else {
            return nil
        }
    }
    
}
