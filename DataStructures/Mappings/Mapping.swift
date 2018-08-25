//
//  Mapping.swift
//  AdvancedDataStructures
//
//  Created by Jeremie Benhamron on 2017-04-17.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import Foundation

public struct Mapping<Domain,Codomain>{
    private var map: (Domain)->Codomain
    private var inverse: (Codomain)->Domain

    public subscript(x:Domain)-> Codomain{
        get{
            return map(x)
        }

    }


    public subscript(y:Codomain)-> Domain{
        get{
            return inverse(y)
        }
    }

    public init(map: @escaping (Domain)->Codomain, inverse: @escaping (Codomain)->Domain)
    {
        self.map = map
        self.inverse = inverse
    }

}
