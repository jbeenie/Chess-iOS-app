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
    static let GreenWhite = ChessBoardTheme(whiteSquareColor:UIColor.white , blackSquareColor: UIColor.green, name:"Green/White")
    static let GreenWhite1 = ChessBoardTheme(whiteSquareColor:AppColor.forestGreen1 , blackSquareColor: AppColor.offWhite1, name:"Green/White1")
    
    static let GreenWhite2 = ChessBoardTheme(whiteSquareColor:AppColor.forestGreen2 , blackSquareColor: AppColor.offWhite2, name:"Green/White2")
    
    static let GreenWhite3 = ChessBoardTheme(whiteSquareColor:AppColor.forestGreen3 , blackSquareColor: AppColor.offWhite3, name:"Green/White3")
    
    static let GreenWhite4 = ChessBoardTheme(whiteSquareColor:AppColor.forestGreen4 , blackSquareColor: AppColor.offWhite4, name:"Green/White4")
    
    
    
    //Gray White
    static let GrayWhite = ChessBoardTheme(whiteSquareColor: UIColor.white, blackSquareColor: UIColor.gray, name:"Gray/White")
    
    
    //Brown Yellow
    static let BrownYellow = ChessBoardTheme(whiteSquareColor: UIColor.yellow, blackSquareColor:UIColor.brown, name:"Brown/Yellow" )
    
    static let list = [GreenWhite,GreenWhite1,GreenWhite2,GreenWhite3,GreenWhite4,GrayWhite,BrownYellow]
}

extension ChessBoardTheme: ChessSetting{
    
    
    //MARK: - Conforming to ChessSetting
    func propertyList() ->[String:String]{
        let representation:[String:String] = [
            "whiteSquareColor": AppColor.injection[whiteSquareColor]!,
            "blackSquareColor": AppColor.injection[blackSquareColor]!,
            "name": name]
        return representation
    }
    
    init?(propertyList:Any?) {
        guard
            let typedPropertyList = propertyList as? [String:String],
            let whiteSquareColor = AppColor.injection[typedPropertyList["whiteSquareColor"]!],
            let blackSquareColor = AppColor.injection[typedPropertyList["blackSquareColor"]!],
            let name = typedPropertyList["name"]
            else {return nil}
        self.init(whiteSquareColor:whiteSquareColor,blackSquareColor:blackSquareColor, name: name)
    }
    
    //MARK: - Debugging
    
    var description:String{
        return "whiteSquareColor: "+whiteSquareColor.description + "," + "blackSquareColor: "+blackSquareColor.description+"\n"
    }
}
