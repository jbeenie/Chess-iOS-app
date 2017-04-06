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
    static func archive(object: Any) -> Data {
        let archivedData = NSKeyedArchiver.archivedData(withRootObject: object)
        return archivedData
    }
    
    static func unArchive(data: Data?)->Any?{
        guard let data = data, let unarchivedData = NSKeyedUnarchiver.unarchiveObject(with: data) else {return nil}
        return unarchivedData
        
    }
    
    
}
