//
//  Injection.swift
//  AdvancedDataStructures
//
//  Created by Jeremie Benhamron on 2017-04-17.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation
import OrderedSet

public struct Injection<Domain:Hashable,Codomain:Hashable>{
    //MARK: - Public API

    //MARK: Computed Properties

    //MARK: Stored Properties
    public var preImage:OrderedSet<Domain>{
        return _preImage
    }
    public var image:OrderedSet<Codomain>{
        return _image
    }


    public var isEmpty:Bool{
        return preImage.isEmpty
    }

    public var pairs:[(Domain,Codomain)]{
        return preImage.enumerated().map
            {(i:Int,x:Domain)->(Domain,Codomain) in return (x,image[i])}
    }

    public var description:String{
        var description = ""
        guard !isEmpty else {return description}
        description += "\(pairs[0])"
        for pair in pairs.suffix(from: 1){
            description += ", \(pair)"
        }
        return description
    }

    //MARK:  Subscritps

    public subscript(x:Domain)-> Codomain?{
        get{
            return getImage(of: x)
        }

        set(y){
            //y is non nil map x to y
            if let y = y{
                map(x: x, toY: y)
            }else{
                //if y is nil unmap x
                unMap(x: x)
            }
        }
    }


    public subscript(y:Codomain)-> Domain?{
        get{
            return getPreImage(of: y)
        }

        set(x){
            //x is non nil map x to y
            if let x = x{
                map(x: x, toY: y)
            }else{
                //if x is nil unmap y
                unMap(y: y)
            }
        }
    }

    //MARK: - Initializers

    public init() {
        self.init(pairs: [])!
    }

    //Fails if an x or y component of pair is equal to one another x or y component of another pair (via ==)
    //eg. following input: [(true, "4"), (true,"5")] would cause failure because true==true

    public init?(pairs:[(Domain,Codomain)]) {
        self._preImage = OrderedSet<Domain>()
        self._image = OrderedSet<Codomain>()
        //Populate domain and codomain using pairs
        for (x,y) in pairs{
            //fail initialization if duplicate x or y component encountered
            guard !self.preImage.contains(x), !self.image.contains(y) else {return nil}
            self.map(x: x, toY: y)
        }
        //double check pairs.count == image.count == preImage.count
        guard pairs.count == image.count, image.count  == preImage.count else {return nil}
    }

    //MARK: - Private implementation

    //MARK: Stored Properties
    private var _preImage:OrderedSet<Domain>
    private var _image:OrderedSet<Codomain>

    //MARK: - Getters
    private func getImage(of x:Domain)->Codomain?{
        guard let i = _preImage.index(of: x) else {return nil}
        return _image[i]
    }


    private func getPreImage(of y:Codomain)->Domain?{
        guard let i = _image.index(of: y) else {return nil}
        return _preImage[i]
    }

    //MARK: - Setters


    //if x or y are already mapped to other elements
    //this functions first removes those mappings
    // and then maps x to y to ensure bijectivity
    private mutating func map(x:Domain, toY y:Codomain){
        unMap(x: x)
        unMap(y: y)
        _preImage.append(x)
        _image.append(y)
    }

    private mutating func unMap(x:Domain){
        guard _preImage.contains(x), let y = self.getImage(of:x) else {return}
        _preImage.remove(x)
        _image.remove(y)
    }

    private mutating func unMap(y:Codomain){
        guard _image.contains(y), let x = self.getPreImage(of:y) else {return}
        _preImage.remove(x)
        _image.remove(y)
    }
}

extension Injection:Equatable{
    public static func ==(lhs: Injection<Domain,Codomain>, rhs: Injection<Domain,Codomain>) -> Bool{
        return lhs.preImage == lhs.preImage && lhs.image == lhs.image
    }
}

extension Injection:Collection{
    public typealias Index = Int

    public var startIndex: Int {
        return 0
    }

    public var endIndex: Int {
        return self.preImage.count
    }

    public func index(after i: Int) -> Int {
        return i + 1
    }

    public subscript(index: Int)->(Domain,Codomain){
        return self.pairs[index]
    }
}
