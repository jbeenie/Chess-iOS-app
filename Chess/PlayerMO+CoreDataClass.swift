//
//  PlayerMO+CoreDataClass.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-04-03.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation
import CoreData


public class PlayerMO: NSManagedObject {
    //For updating and creating Player Entires
    class func playerWith(name:String, inManagedObjectContext context:NSManagedObjectContext)->PlayerMO?{
        //configure the fetch request
        let request: NSFetchRequest<PlayerMO> = PlayerMO.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", name)
        //execute the fetch request and verify if player already exists
        if let player = (try? context.fetch(request))?.first{
            //if it does exist in the db simply return it
            return player
        }else if let player = NSEntityDescription.insertNewObject(forEntityName: PlayerMO.entity().name!, into: context) as? PlayerMO{
            //if it doesn't, create it in the database
            player.name = name
            return player
        }
        return nil
    }
}
