//
//  ChessBoardTheme.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-04-25.
//  Copyright © 2017 beenie.inc. All rights reserved.
//


import UIKit

struct ChessBoardTheme:Equatable,Hashable{
    let whiteSquareColor:UIColor
    let blackSquareColor:UIColor
    let name: String
    
    //MARK: - Equatable & Hashalble
    var hashValue: Int{
        return whiteSquareColor.hashValue ^ blackSquareColor.hashValue
    }
    
    static func == (lhs:ChessBoardTheme,rhs:ChessBoardTheme)->Bool{
        return lhs.whiteSquareColor == rhs.whiteSquareColor && lhs.blackSquareColor == rhs.blackSquareColor
    }
    
    
    //MARK: - Initializers
    
    init(whiteSquareColor: UIColor, blackSquareColor: UIColor, name:String){
        self.whiteSquareColor = whiteSquareColor
        self.blackSquareColor = blackSquareColor
        self.name = name
    }
}

//List of chessboard themes
struct ChessBoardThemes{
    
    //Green White options
    static let GreenWhite = ChessBoardTheme(whiteSquareColor:UIColor.white , blackSquareColor: UIColor.green, name:"GreenWhite")
    static let GreenWhite1 = ChessBoardTheme(whiteSquareColor:AppColors.forestGreen1 , blackSquareColor: AppColors.offWhite1, name:"GreenWhite1")
    
    static let GreenWhite2 = ChessBoardTheme(whiteSquareColor:AppColors.forestGreen2 , blackSquareColor: AppColors.offWhite2, name:"GreenWhite2")
    
    static let GreenWhite3 = ChessBoardTheme(whiteSquareColor:AppColors.forestGreen3 , blackSquareColor: AppColors.offWhite3, name:"GreenWhite3")
    
    static let GreenWhite4 = ChessBoardTheme(whiteSquareColor:AppColors.forestGreen4 , blackSquareColor: AppColors.offWhite4, name:"GreenWhite4")
    
    
    
    //Gray White
    static let GrayWhite = ChessBoardTheme(whiteSquareColor: UIColor.white, blackSquareColor: UIColor.gray, name:"GrayWhite")
    
    
    //Brown Yellow
    static let BrownYellow = ChessBoardTheme(whiteSquareColor: UIColor.yellow, blackSquareColor:UIColor.brown, name:"BrownYellow" )
    
    static let list = [GreenWhite,GreenWhite1,GreenWhite2,GreenWhite3,GreenWhite4,GrayWhite,BrownYellow]
}

extension ChessBoardTheme: ChessSetting{
    //TODO: Change to bijection
    private static var colorMap:[String:UIColor]{
        return ["white":UIColor.white,
                "gray":UIColor.gray,
                "green":UIColor.green,
                "yellow":UIColor.yellow,
                "brown":UIColor.brown
        ]
    }
    
    //MARK: - Conforming to ChessSetting
    func propertyList() ->[String:String]{
        let representation:[String:String] = [
            "whiteSquareColor": ChessBoardTheme.colorMap.someKeyFor(value:whiteSquareColor)!,
            "blackSquareColor": ChessBoardTheme.colorMap.someKeyFor(value:blackSquareColor)!,
            "name": name]
        return representation
    }
    
    init?(propertyList:Any?) {
        guard
            let typedPropertyList = propertyList as? [String:String],
            let whiteSquareColor = ChessBoardTheme.colorMap[typedPropertyList["whiteSquareColor"]!],
            let blackSquareColor = ChessBoardTheme.colorMap[typedPropertyList["blackSquareColor"]!],
            let name = typedPropertyList["name"]
            else {return nil}
        self.init(whiteSquareColor:whiteSquareColor,blackSquareColor:blackSquareColor, name: name)
    }
    
    //MARK: - Debugging
    
    var description:String{
        return "whiteSquareColor: "+whiteSquareColor.description + "," + "blackSquareColor: "+blackSquareColor.description+"\n"
    }
}
