//
//  PlayerMO+CoreDataProperties.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-04-03.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation
import CoreData


extension PlayerMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayerMO> {
        return NSFetchRequest<PlayerMO>(entityName: "Player")
    }

    @NSManaged public var name: String?
    @NSManaged public var gamesAsBlack: NSSet?
    @NSManaged public var gamesAsWhite: NSSet?

}

// MARK: Generated accessors for gamesAsBlack
extension PlayerMO {

    @objc(addGamesAsBlackObject:)
    @NSManaged public func addToGamesAsBlack(_ value: ChessGameMO)

    @objc(removeGamesAsBlackObject:)
    @NSManaged public func removeFromGamesAsBlack(_ value: ChessGameMO)

    @objc(addGamesAsBlack:)
    @NSManaged public func addToGamesAsBlack(_ values: NSSet)

    @objc(removeGamesAsBlack:)
    @NSManaged public func removeFromGamesAsBlack(_ values: NSSet)

}

// MARK: Generated accessors for gamesAsWhite
extension PlayerMO {

    @objc(addGamesAsWhiteObject:)
    @NSManaged public func addToGamesAsWhite(_ value: ChessGameMO)

    @objc(removeGamesAsWhiteObject:)
    @NSManaged public func removeFromGamesAsWhite(_ value: ChessGameMO)

    @objc(addGamesAsWhite:)
    @NSManaged public func addToGamesAsWhite(_ values: NSSet)

    @objc(removeGamesAsWhite:)
    @NSManaged public func removeFromGamesAsWhite(_ values: NSSet)

}
