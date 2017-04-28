//
//  ChessGameSettings.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-20.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

class ChessGameSettings{
    struct Constants{
        static let userDefaultsKey = "LatestGameSettings"
    }
    
    struct Default{
        static let maxTakebacks:TakebackCount = TakebackCount.Finite(1)
        static let takeBacksEnabled:Bool = true
        static let clockTime:Int = 5 * 60 // 5 minutes
        static let clockEnabled:Bool = true
    }
    
    static let defaultGameSettings = ChessGameSettings(
        maxTakebacks: Default.maxTakebacks,
        takeBacksEnabled: Default.takeBacksEnabled,
        clockTime: Default.clockTime,
        clockEnabled: Default.clockEnabled)
    
    //MARK: - Stored Properties
    var clockEnabled:Bool
    var clockTime:Int
    var takeBacksEnabled:Bool
    var maxTakebacks:TakebackCount
    
    //MARK: - Computed Properties
    
    var effectiveMaxTakebacksCount:TakebackCount{
        return takeBacksEnabled ? maxTakebacks : TakebackCount.Finite(0)
    }
    
    //MARK: - Accessing Global Settings
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
    var globalSettings:ChessSettings = ChessSettings()
    
    init(maxTakebacks:TakebackCount,takeBacksEnabled:Bool,clockTime:Int,clockEnabled:Bool){
        self.maxTakebacks = maxTakebacks
        self.takeBacksEnabled = takeBacksEnabled
        self.clockTime = clockTime
        self.clockEnabled = clockEnabled
    }
    
    
    //MARK: Save & Load game settings to and from user defaults
    internal func save(){
        let defaults = UserDefaults.standard
        let data = Archiver.archive(object: self.propertyList())
        defaults.set(data, forKey: Constants.userDefaultsKey)
    }
    
    internal static func loadGameSettings()->ChessGameSettings{
        let defaults = UserDefaults.standard
        if let data = defaults.object(forKey: Constants.userDefaultsKey){
            let pListRepresentation = Archiver.unArchive(data: data as? Data)
            if let gameSettings = ChessGameSettings(propertyList: pListRepresentation){
                return gameSettings
            }
        }
        return defaultGameSettings
    }
    
    
    //MARK: - Conforming to ChessSetting
    func propertyList() -> [String:Any] {
        let representation:[String:Any] = [
            "takeBacksEnabled":takeBacksEnabled,
            "maxTakebacks":maxTakebacks.toInt(),
            "clockEnabled":clockEnabled,
            "clockTime":clockTime]
        return representation
    }
    
    required convenience init?(propertyList:Any?) {
        guard let pList = propertyList as? [String:Any],
            let intMaxTakebacks = pList["maxTakebacks"] as? Int,
            let maxTakebacks = TakebackCount(integer: intMaxTakebacks),
            let takeBacksEnabled = pList["takeBacksEnabled"] as? Bool,
            let clockTime = pList["clockTime"] as? Int,
            let clockEnabled = pList["clockEnabled"] as? Bool
        else{return nil}
        

        
        self.init(maxTakebacks: maxTakebacks, takeBacksEnabled: takeBacksEnabled, clockTime: clockTime, clockEnabled: clockEnabled)
    }
    
}
