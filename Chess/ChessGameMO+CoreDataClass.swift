//
//  ChessGameMO+CoreDataClass.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-04-03.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation
import CoreData


public class ChessGameMO: NSManagedObject {
    class func chessGameWith(chessGameInfo:ChessGameInfo, inManagedObjectContext context:NSManagedObjectContext)->ChessGameMO?{
        //if an Object ID is provided return the existing object
        if let id = chessGameInfo.chessGameID{
           return context.object(with: id) as? ChessGameMO
        
        //otherwise add the object to the database
        }else if let chessGameMO = NSEntityDescription.insertNewObject(forEntityName: self.entity().name!, into: context) as? ChessGameMO{
            chessGameMO.updateWith(chessGameInfo: chessGameInfo, inManagedObjectContext: context)
            //ensure date created and modified are exactly the same when first created
            let now = NSDate()
            chessGameMO.created = now
            chessGameMO.modified = now
        }
        return nil
    }
    
    func updateWith(chessGameInfo:ChessGameInfo, inManagedObjectContext context:NSManagedObjectContext){
        let now = NSDate()
        self.modified = now
        self.whitePlayer = PlayerMO.playerWith(name: chessGameInfo.whitePlayer, inManagedObjectContext: context)
        self.blackPlayer = PlayerMO.playerWith(name: chessGameInfo.blackPlayer, inManagedObjectContext: context)
        self.snapShot = ChessGameSnapShotMO.insertNewObjectWith(
            chessGame: chessGameInfo.chessGame,
            chessClock: chessGameInfo.chessClock,
            whiteTakebacksRemaining: chessGameInfo.whiteTakebacksRemaining,
            blackTakebacksRemaining: chessGameInfo.blackTakebacksRemaining,
            inManagedObjectContext: context)
    }
}

