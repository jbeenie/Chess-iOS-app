//
//  ChessGameMO+CoreDataProperties.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-04-03.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation
import CoreData


extension ChessGameMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChessGameMO> {
        return NSFetchRequest<ChessGameMO>(entityName: "ChessGame")
    }

    @NSManaged public var created: NSDate?
    @NSManaged public var modified: NSDate?
    @NSManaged public var blackPlayer: PlayerMO?
    @NSManaged public var whitePlayer: PlayerMO?
    @NSManaged public var snapShot: ChessGameSnapShotMO?

}
