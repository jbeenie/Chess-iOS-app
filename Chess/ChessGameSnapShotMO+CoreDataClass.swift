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
    class func insertNewObjectWith(chessGame:ChessGame,chessClock:ChessClock?,whiteTakebacksRemaining:TakebackCount?, blackTakebacksRemaining:TakebackCount?, inManagedObjectContext context:NSManagedObjectContext)->ChessGameSnapShotMO{
        let chessGameSnapShotMO = NSEntityDescription.insertNewObject(forEntityName: ChessGameSnapShotMO.entity().name!, into: context) as! ChessGameSnapShotMO
        
        //Set the take backs if necessary
        if let whiteTakebacksRemaining = whiteTakebacksRemaining, let blackTakebacksRemaining = blackTakebacksRemaining{
            chessGameSnapShotMO.whiteTakebacksRemaining = takeBackCountToInt32(takebackCount: whiteTakebacksRemaining)
            chessGameSnapShotMO.blackTakebacksRemaining = takeBackCountToInt32(takebackCount: blackTakebacksRemaining)
        }
        //Set the clock if necessary
        if chessClock != nil{
            //TODO:convert to NSData
            chessGameSnapShotMO.clockSnapShot = NSData()
        }
        //convert to NSData
        chessGameSnapShotMO.gameSnapShot = NSData()
        return chessGameSnapShotMO
    }
    
    class func takeBackCountToInt32(takebackCount:TakebackCount)->Int32{
        switch takebackCount {
        case .Infinite:
            return INT32_MAX
        case .Finite(let count):
            return Int32(count)
        }
    }
}
