//
//  ChessGameMO+CoreDataClass.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-04-03.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation
import CoreData

struct ChessGameInfo{
    var playerNames:PlayerNames
    var snapShot:ChessGameSnapShot
}

public class ChessGameMO: NSManagedObject {
    //MARK: - Creating
    //Creating new chessGameMO entires
    class func createChessGameWith( chessGameInfo:ChessGameInfo,
                                    inManagedObjectContext context:NSManagedObjectContext,
                                    completion:@escaping (ChessGameMO?)->()
        ){
        
        //perfrom on contexts q for thread safety
        context.performAndWait{
            
            //create new empty ChessGameMO in NSManagedObjectContext
            guard let chessGameMO = NSEntityDescription.insertNewObject(forEntityName: self.entity().name!, into: context) as? ChessGameMO
            else
            {
                completion(nil)
                print("Could not create new ChessGameMO in DB")
                return
            }
            
            //initialize chessGameMO values
            chessGameMO.initializeWith(chessGameInfo: chessGameInfo, inManagedObjectContext: context)
            //execute completion handler
            completion(chessGameMO)
        }
    }
    
    //MARK: Helper method used to help set values of ChessGameMO when they are created
    private func initializeWith(chessGameInfo:ChessGameInfo, inManagedObjectContext context:NSManagedObjectContext){
        self.whitePlayer = PlayerMO.playerWith(name: chessGameInfo.playerNames.white, inManagedObjectContext: context)
        self.blackPlayer = PlayerMO.playerWith(name: chessGameInfo.playerNames.black, inManagedObjectContext: context)
        self.snapShot = ChessGameSnapShotMO.insertNewObjectWith(
            snapShot: chessGameInfo.snapShot,
            inManagedObjectContext: context)
        
        //ensure date created and modified are exactly the same when first created
        let now = NSDate()
        self.created = now
        self.modified = now
    }
    
    //MARK: - Updating
    //updating chessGameMO entires - update the their ChessGameSnapShotMO relationship
    class func updateChessGameHaving(id: NSManagedObjectID,
                                     inManagedObjectContext context:NSManagedObjectContext,
                                     with snapShot: ChessGameSnapShot,
                                     completion:@escaping (ChessGameMO)->()){
        context.performAndWait{
            //Get the object to update using the provided ID
            guard !id.isTemporaryID else {print("Temporary ID!");return}
            guard let chessGameMO = context.object(with: id) as? ChessGameMO else{
                print("Error casting!");
                return
            }
            
            //delete old game state
            if let oldSnapShot = chessGameMO.snapShot{
                context.delete(oldSnapShot)
            }

            //create and link updated game state
            chessGameMO.snapShot = ChessGameSnapShotMO.insertNewObjectWith(
                snapShot: snapShot,
                inManagedObjectContext: context)
            

            //update the the modified field
            let now = NSDate()
            chessGameMO.modified = now
            //execute completion handler
            completion(chessGameMO)
        }
        
    }
}

