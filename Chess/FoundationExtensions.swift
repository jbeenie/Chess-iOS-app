//
//  FoundationExtensions.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-22.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

extension String {
    var length: Int {
        return self.characters.count
    }
}

extension Bool:ChessSetting{
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

extension Dictionary where Value: Equatable {
    func allKeys(forValue val: Value) -> [Key] {
        return self.filter { $1 == val }.map { $0.0 }
    }
    
    func someKeyFor(value: Value) -> Key? {
        
        guard let index = index(where: { $0.1 == value }) else {
            return nil
        }
        
        return self[index].0
    }
}

extension Dictionary{
    init(_ pairs: [Element]) {
        self.init()
        for (k, v) in pairs {
            self[k] = v
        }
    }
    //MARK: Dictionary Mappings
    func mapValues<OutValue>( transform: (Value) throws -> OutValue) rethrows -> [Key: OutValue] {
        return Dictionary<Key, OutValue>(try self.map { (k:Key, v:Value) in (k, try transform(v)) })
    }
    
    func mapPairs<OutKey: Hashable, OutValue>(transform: (Element) throws -> (OutKey, OutValue)) rethrows -> [OutKey: OutValue] {
        return Dictionary<OutKey, OutValue>(try self.map(transform))
    }
    
    func filterPairs( includeElement: (Element) throws -> Bool) rethrows -> [Key: Value] {
        return Dictionary(try filter(includeElement))
    }
}
