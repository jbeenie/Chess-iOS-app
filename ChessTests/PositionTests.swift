//
//  PositionTests.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-16.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import XCTest
@testable import Chess

class PositionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //MARK: test IsOnSameRow
    func testIsOnSameRow() {
        
        guard var position1 = Position(row: 1, col: 1) else{
            XCTFail("Improperly formed position1")
            return
        }
        guard var position2 = Position(row: 2, col: 1) else {
            XCTFail("Improperly formed position2")
            return
        }
        //MARK: Failure Tests
        XCTAssert((position1.isOnSameRow(as: position2) == nil))
        
        if position1.set(row: 2, col: 3) && position2.set(row: 7, col: 4){
            XCTAssert((position1.isOnSameRow(as: position2) == nil))
        }
        
        //MARK: Success Tests
        if position1.set(row: 2, col: 2) && position2.set(row: 2, col: 2){
            XCTAssert((position1.isOnSameRow(as: position2) == 0))
        }
        
        if position1.set(row: 2, col: 2) && position2.set(row: 2, col: 3){
            XCTAssert((position1.isOnSameRow(as: position2) == 1))
        }
        
        if position1.set(row: 2, col: 2) && position2.set(row: 2, col: 4){
            XCTAssert((position1.isOnSameRow(as: position2) == 2))
        }
        
    }
    
    func testIsOnSameColumn() {
        
        guard var position1 = Position(row: 1, col: 5) else{
            XCTFail("Improperly formed position1")
            return
        }
        guard var position2 = Position(row: 1, col: 1) else {
            XCTFail("Improperly formed position2")
            return
        }
        //MARK: Failure Tests
        XCTAssert((position1.isOnSameColumn(as: position2) == nil))
        
        
        if position1.set(row: 2, col: 3) && position2.set(row: 7, col: 4){
            XCTAssert((position1.isOnSameColumn(as: position2) == nil))
        }
        
        //MARK: Success Tests
        if position1.set(row: 3, col: 3) && position2.set(row: 3, col: 3){
            XCTAssert((position1.isOnSameColumn(as: position2) == 0))
        }
        
        if position1.set(row: 3, col: 3) && position2.set(row: 2, col: 3){
            XCTAssert((position1.isOnSameColumn(as: position2) == 1))
        }
        
        if position1.set(row: 3, col: 3) && position2.set(row: 1, col: 3){
            XCTAssert((position1.isOnSameColumn(as: position2) == 2))
        }
    }
    
    func testIsOnSameDiagonal(){
        guard var position1 = Position(row: 0, col: 0) else{
            XCTFail("Improperly formed position1")
            return
        }
        guard var position2 = Position(row: 7, col: 0) else {
            XCTFail("Improperly formed position2")
            return
        }
        //MARK: Failure Tests
        //same col
        XCTAssert((position1.isOnSameDiagonal(as: position2) == nil))
        //same row
        if position1.set(row: 2, col: 3) && position2.set(row: 2, col: 5){
            XCTAssert((position1.isOnSameDiagonal(as: position2) == nil))
        }
        //off row, off col, off diag 1
        if position1.set(row: 2, col: 3) && position2.set(row: 7, col: 5){
            XCTAssert((position1.isOnSameDiagonal(as: position2) == nil))
        }
        
        //off row, off col, off diag 2
        if position1.set(row: 7, col: 0) && position2.set(row: 0, col: 1){
            XCTAssert((position1.isOnSameDiagonal(as: position2) == nil))
        }
        
        //MARK: Success Tests
        //same position
        if position1.set(row: 3, col: 3) && position2.set(row: 3, col: 3){
            XCTAssert((position1.isOnSameDiagonal(as: position2) == 0))
        }
        // diagonal / direction
        if position1.set(row: 7, col: 0) && position2.set(row: 0, col: 7){
            XCTAssert((position1.isOnSameDiagonal(as: position2) == 7))
        }
        // diagonal \ direction
        if position1.set(row: 6, col: 6) && position2.set(row: 1, col: 1){
            XCTAssert((position1.isOnSameDiagonal(as: position2) == 5))
        }
        
        //MARK: signed = true
        //MARK: Success Tests
        //same position
        if position1.set(row: 3, col: 3) && position2.set(row: 3, col: 3){
            let answer = 0
            let result = position1.isOnSameDiagonal(as: position2, signed: true)
            XCTAssert(result == answer, "Result :\(String(describing: result)) != \(answer): Answer")
        }
        
        // diagonal / direction
        if position1.set(row: 7, col: 0) && position2.set(row: 0, col: 7){
            let answer = 7
            let result = position1.isOnSameDiagonal(as: position2, signed: true)
            XCTAssert(result == answer, "Result :\(String(describing: result)) != \(answer): Answer")
        }
        
        // diagonal / direction
        if position1.set(row: 7, col: 0) && position2.set(row: 0, col: 7){
            let answer = -7
            let result = position2.isOnSameDiagonal(as: position1, signed: true)
            XCTAssert(result == answer, "Result :\(String(describing: result)) != \(answer): Answer")
        }
        
        // diagonal \ direction
        if position1.set(row: 6, col: 6) && position2.set(row: 1, col: 1){
            let answer = 5
            let result = position1.isOnSameDiagonal(as: position2, signed: true)
            XCTAssert(result == answer, "Result :\(String(describing: result)) != \(answer): Answer")
        }
        
        // diagonal \ direction
        if position1.set(row: 6, col: 6) && position2.set(row: 1, col: 1){
            let answer = -5
            let result = position2.isOnSameDiagonal(as: position1, signed: true)
            XCTAssert(result == answer, "Result :\(String(describing: result)) != \(answer): Answer")
        }
    }
    
    func testIsLPositionedRelative(){
        guard var position1 = Position(row: 0, col: 0) else{
            XCTFail("Improperly formed position1")
            return
        }
        guard var position2 = Position(row: 7, col: 0) else {
            XCTFail("Improperly formed position2")
            return
        }
        //MARK: Failure Tests
        //same col
        XCTAssert(position1.isLPositionedRelative(to: position2) == false)
        //same row
        if position1.set(row: 2, col: 3) && position2.set(row: 2, col: 5){
            XCTAssert(position1.isLPositionedRelative(to: position2) == false)
        }
        //off row, off col, off diag 1
        if position1.set(row: 2, col: 3) && position2.set(row: 7, col: 5){
            XCTAssert(position1.isLPositionedRelative(to: position2) == false)
        }
        
        //off row, off col, off diag 2
        if position1.set(row: 7, col: 0) && position2.set(row: 0, col: 1){
            XCTAssert(position1.isLPositionedRelative(to: position2) == false)
        }
        
        //same position
        if position1.set(row: 4, col: 4) && position2.set(row: 4, col: 4){
            XCTAssert(position1.isLPositionedRelative(to: position2) == false)
        }
        
        //MARK: Success Tests
        //knight specific tests
        //1
        if position1.set(row: 4, col: 4) && position2.set(row: 3, col: 2){
            XCTAssert(position1.isLPositionedRelative(to: position2))
        }
        //2
        if position2.set(row: 2, col: 3){
            XCTAssert(position1.isLPositionedRelative(to: position2))
        }
        //3
        if  position2.set(row: 2, col: 5){
            XCTAssert(position1.isLPositionedRelative(to: position2))
        }
        //4
        if  position2.set(row: 3, col: 6){
            XCTAssert(position1.isLPositionedRelative(to: position2))
        }
        //5
        if  position2.set(row: 5, col: 6){
            XCTAssert(position1.isLPositionedRelative(to: position2))
        }
        //6
        if  position2.set(row: 6, col: 5){
            XCTAssert(position1.isLPositionedRelative(to: position2))
        }
        //7
        if  position2.set(row: 6, col: 3){
            XCTAssert(position1.isLPositionedRelative(to: position2))
        }
        //8
        if  position2.set(row: 5, col: 2){
            XCTAssert(position1.isLPositionedRelative(to: position2))
        }
    }
    
    func testSquaresOnSameRow(){
        guard let position1 = Position(row: 0, col: 0) else{
            XCTFail("Improperly formed position1")
            return
        }
        guard let position2 = Position(row: 5, col: 6) else {
            XCTFail("Improperly formed position2")
            return
        }
        
        for position in position1.squaresOnSameRow{
            XCTAssert((position1.isOnSameRow(as: position) != nil))
        }
        XCTAssert(position1.squaresOnSameRow.count == 8)
        
        for position in position2.squaresOnSameRow{
            XCTAssert((position2.isOnSameRow(as: position) != nil))
        }
        XCTAssert(position2.squaresOnSameRow.count == 8)
    }

    func testSquaresOnSameCol(){
        guard let position1 = Position(row: 0, col: 0) else{
            XCTFail("Improperly formed position1")
            return
        }
        guard let position2 = Position(row: 5, col: 6) else {
            XCTFail("Improperly formed position2")
            return
        }
        for position in position1.squaresOnSameColumn{
            XCTAssert((position1.isOnSameColumn(as: position) != nil))
        }
        XCTAssert(position1.squaresOnSameColumn.count == 8)
    
        for position in position2.squaresOnSameColumn{
            XCTAssert((position2.isOnSameColumn(as: position) != nil))
        }
        XCTAssert(position2.squaresOnSameColumn.count == 8)
    }
    
    func testSquaresOnSameDiagonal(){
        guard let position1 = Position(row: 0, col: 0) else{
            XCTFail("Improperly formed position1")
            return
        }
        guard let position2 = Position(row: 5, col: 6) else {
            XCTFail("Improperly formed position2")
            return
        }
        for position in position1.squaresOnSameDiagonal{
            XCTAssert((position1.isOnSameDiagonal(as: position) != nil))
        }
        XCTAssert(position1.squaresOnSameDiagonal.count == 8)
        
        for position in position2.squaresOnSameDiagonal{
            XCTAssert((position2.isOnSameDiagonal(as: position) != nil))
        }
        XCTAssert(position2.squaresOnSameDiagonal.count == 10)
    }
    
    func testSquareswithLRelativePosition(){
        guard let position1 = Position(row: 0, col: 0) else{
            XCTFail("Improperly formed position1")
            return
        }
        guard let position2 = Position(row: 4, col: 4) else {
            XCTFail("Improperly formed position2")
            return
        }
        guard let position3 = Position(row: 2, col:1) else {
            XCTFail("Improperly formed position2")
            return
        }
        
        print(position1.squareswithLRelativePosition)
        for position in position1.squareswithLRelativePosition{
            XCTAssert(position1.isLPositionedRelative(to: position))
        }
        XCTAssert(position1.squareswithLRelativePosition.count == 2)
        
        print(position2.squareswithLRelativePosition)
        for position in position2.squareswithLRelativePosition{
            XCTAssert(position2.isLPositionedRelative(to: position))
        }
        XCTAssert(position2.squareswithLRelativePosition.count == 8)
        
        print(position3.squareswithLRelativePosition)
        for position in position3.squareswithLRelativePosition{
            XCTAssert(position3.isLPositionedRelative(to: position))
        }
        XCTAssert(position3.squareswithLRelativePosition.count == 6)
    }
    
    

}
