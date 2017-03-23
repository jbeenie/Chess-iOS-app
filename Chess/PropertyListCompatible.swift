//
//  PropertyListCompatible.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-22.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

protocol PropertyListCompatible {
    func propertyListRepresentation() -> NSDictionary
    init?(propertyListRepresentation:NSDictionary?)
}
