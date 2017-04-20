//
//  CoreDataUtilities.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-04-18.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation
import CoreData

class CoreDataUtilities{
    
    
    class func save(context:NSManagedObjectContext)
    {
        do {
            try context.save()
            print("Succeeded commiting changes to DB")
        } catch let error as NSError {
            print("Error saving context:\(error)\n\n")
        }
    }
    
    
}
