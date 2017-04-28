//
//  ChessGameSnapShotMO+CoreDataClass.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-04-03.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation
import CoreData


public class ChessGameSnapShotMO: NSManagedObject {
    
    class func insertNewObjectWith(snapShot:ChessGameSnapShot,
                                   inManagedObjectContext context:NSManagedObjectContext
        )->ChessGameSnapShotMO{
        
        let chessGameSnapShotMO = NSEntityDescription.insertNewObject(forEntityName: ChessGameSnapShotMO.entity().name!, into: context) as! ChessGameSnapShotMO
        
        //Set the take backs if necessary
        chessGameSnapShotMO.whiteTakebacksRemaining = Int32(snapShot.whiteTakebacksRemaining.toInt())
        chessGameSnapShotMO.blackTakebacksRemaining = Int32(snapShot.blackTakebacksRemaining.toInt())
    
        //Set the clock if necessary
        if let chessClock = snapShot.clockSnapShot{
            chessGameSnapShotMO.clockSnapShot = Archiver.archive(object: chessClock) as NSData
        }
        //convert to NSData
        chessGameSnapShotMO.gameSnapShot = Archiver.archive(object: snapShot.gameSnapShot) as NSData
        return chessGameSnapShotMO
    }
}
