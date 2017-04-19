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
    
    class func insertNewObjectWith(chessGame:ChessGame,
                                   chessClock:ChessClock?,
                                   whiteTakebacksRemaining:TakebackCount,
                                   blackTakebacksRemaining:TakebackCount,
                                   inManagedObjectContext context:NSManagedObjectContext
        )->ChessGameSnapShotMO{
        
        let chessGameSnapShotMO = NSEntityDescription.insertNewObject(forEntityName: ChessGameSnapShotMO.entity().name!, into: context) as! ChessGameSnapShotMO
        
        //Set the take backs if necessary
        chessGameSnapShotMO.whiteTakebacksRemaining = Int32(whiteTakebacksRemaining.toInt())
        chessGameSnapShotMO.blackTakebacksRemaining = Int32(blackTakebacksRemaining.toInt())
    
        //Set the clock if necessary
        if let chessClock = chessClock{
            chessGameSnapShotMO.clockSnapShot = Archiver.archive(object: chessClock) as NSData
        }
        //convert to NSData
        chessGameSnapShotMO.gameSnapShot = Archiver.archive(object: chessGame) as NSData
        return chessGameSnapShotMO
    }
    
    //MARK: - Delete
    
    class func delete(chessGameSnapShotMO:ChessGameMO, inManagedObjectContext context:NSManagedObjectContext){
        context.perform {
            //delete the game
            context.delete(chessGameSnapShotMO)
            //save the changes
            CoreDataUtilities.save(context:context)
        }
    }
}
