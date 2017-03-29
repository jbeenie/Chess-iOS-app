//
//  FoundationExtensions.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-22.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

extension Bool:ChessSetting{
    func not()->Bool{
        return !self
    }
    
    func propertyListRepresentation() -> NSDictionary{
        let representation:[String:Any] = ["self":self as AnyObject]
        return representation as NSDictionary
    }
    init?(propertyListRepresentation:NSDictionary?){
        guard let plist = propertyListRepresentation else {return nil}
        if let value = plist["self"] as? Bool{
            self = value
        } else {
            return nil
        }

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

//returns the index of an element in a 2D array
//return value (Int,Int) = (row, col) = (index in outter array, index in inner array)
extension Array where Element : Collection,
Element.Iterator.Element : Equatable, Element.Index == Int {
    func index(of x: Element.Iterator.Element) -> (Int, Int)? {
        for (i, row) in self.enumerated() {
            if let j = row.index(of: x) {
                return (i, j)
            }
        }
        return nil
    }
}
