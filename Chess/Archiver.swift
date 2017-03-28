//
//  Archiver.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-21.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

//Utility Object used to archive and unarchive data
final class Archiver{
    //MARK: - Ensure class cannot be instantiated
    private init(){}
    
    //MARK: - Archiving and Unarchiving data
    static func archive(data: NSDictionary) -> NSData {
        let archivedData = NSKeyedArchiver.archivedData(withRootObject: data)
        return archivedData as NSData
    }
    
    static func unArchive(data: Any)->NSDictionary?{
        guard let data = (data as? Data), let unarchivedData = NSKeyedUnarchiver.unarchiveObject(with: data) else {return nil}
        return unarchivedData as? NSDictionary
        
    }
    
    
}
