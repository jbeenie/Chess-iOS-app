//
//  FoundationExtensions.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-22.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

extension Bool{
    func not()->Bool{
        return !self
    }
}

extension Set{
    static func +(lhs:Set, rhs: Set)->Set{
        return lhs.union(rhs)
    }
    
    static func += (lhs: inout Set, rhs: Set) {
        lhs = lhs+rhs
    }
    
    static func -(lhs: Set, rhs: Set)->Set{
        var difference = lhs
        difference.subtract(rhs)
        return difference
    }
    
}

extension Array {
    public init(count: Int, elementCreator: @autoclosure () -> Element) {
        self = (0 ..< count).map { _ in elementCreator() }
    }
}
