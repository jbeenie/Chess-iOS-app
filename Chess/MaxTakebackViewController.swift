//
//  MaxTakebackViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-16.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

enum TakebackCount{
    case Finite(Int)
    case Infinite
    
    var isZero:Bool{
        switch self{
        case .Finite(let count):
            return count == 0
        case .Infinite:
            return false
        }
    }
    
    mutating func decrement(){
        switch self{
        case .Finite(let count):
            let newCount = count>0 ? count-1 : count
            self = TakebackCount.Finite(newCount)
        case .Infinite:
            break
        }
    }
    
    mutating func incrementIfLess(than maxTakeBackCount:TakebackCount){
        switch (self,maxTakeBackCount){
        case (.Finite(let count),.Finite(let maxCount)):
            let newCount = maxCount>count ? count+1 : count
            self = TakebackCount.Finite(newCount)
        default:
            break
        }
    }
    
    var description:String{
        switch self{
        case .Finite(let count):
            return String(count)
        case .Infinite:
            return "∞"
        }
    }
}

class MaxTakebackViewController: IntegerSliderViewController {
    //MARK: - Constants
    struct Constants{
        static let maxFiniteTakeBacks = 10
        static let minTakeBacks = 1
    }
    
    struct Default{
        static let takebackCount = 1
    }
    
    //MARK: -  Conversion between Int and TakebackCount
    private func intToTakeBacks(int:Int)->TakebackCount{
        if int == maximumIntegerValue{
            return TakebackCount.Infinite
        }else {
            return TakebackCount.Finite(int)
        }
    }
    
    private func takeBacksToInt(takebacks:TakebackCount)->Int{
        switch takebacks {
        case .Finite(let count):
            return count
        case .Infinite:
            return maximumIntegerValue
        }
    }
    
    //MARK: - Model
    internal var takebacks:TakebackCount = TakebackCount.Finite(Default.takebackCount)
    
    //MARK: updating Model    
    override func updateModel(givenCurrentInteger sliderValue: Int) {
        takebacks = intToTakeBacks(int:sliderValue)
    }
    
    //MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        exitClosure = updateGameSettings
        _ = minMaxSliderValues(intMin: Constants.minTakeBacks, intMax: Constants.maxFiniteTakeBacks+1)
        _ = initialSliderValue(intValue: takeBacksToInt(takebacks: takebacks))
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Converting Integer Data to String
    override internal func toString(intData: Int) -> String {
        return intToTakeBacks(int: intData).description
    }
    
    //MARK: - Update VC returned to with final takeback count
    private func updateGameSettings(){
        guard let gameSettingsVC = self.previousViewController as? ChessGameSettingsTableTableViewController else{return}
        gameSettingsVC.maxTakebackCount = takebacks
    }
}

extension TakebackCount:Equatable{
    static func == (lhs:TakebackCount, rhs:TakebackCount)->Bool{
        switch (lhs,rhs) {
        case (.Finite(let leftCount),.Finite(let rightCount)):
            return leftCount == rightCount
        case (.Infinite,.Infinite):
            return true
        default:
            return false
        }
    }
}
