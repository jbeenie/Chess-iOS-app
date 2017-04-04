//
//  ChessGameSnapShotMO+CoreDataProperties.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-04-03.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation
import CoreData


extension ChessGameSnapShotMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChessGameSnapShotMO> {
        return NSFetchRequest<ChessGameSnapShotMO>(entityName: "ChessGameSnapShot")
    }

    @NSManaged public var gameSnapShot: NSData?
    @NSManaged public var clockSnapShot: NSData?
    @NSManaged public var whiteTakebacksRemaining: Int32
    @NSManaged public var blackTakebacksRemaining: Int32
    @NSManaged public var chessGame: ChessGameMO?

}
