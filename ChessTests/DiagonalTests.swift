//
//  DiagonalTests.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-16.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import XCTest
@testable import Chess

class DiagonalTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateDiagonalFromPositions() {
        //MARK: Success Tests
        guard let position1 = Position(row: 4, col: 4) else {
            XCTFail("Improperly formed position1")
            return
        }
        guard var position2 = Position(row: 2, col: 2) else {
            XCTFail("Improperly formed position2")
            return
        }
        guard var diagonal = Diagonal(position1: position1, position2: position2) else{
            XCTFail("Improperly formed diagonal")
            return
        }
        //corner top left
        XCTAssert(diagonal.direction == Diagonal.Direction.toTopLeft)
        
        //corner top right
        _ = position2.set(row: 2, col: 6)
        diagonal = Diagonal(position1: position1, position2: position2)!
        XCTAssert(diagonal.direction == Diagonal.Direction.toTopRight)
        
        
        //corner bottow right
        _ = position2.set(row: 6, col: 6)
        diagonal = Diagonal(position1: position1, position2: position2)!
        XCTAssert(diagonal.direction == Diagonal.Direction.toTopLeft)
        
        //corner bottom left
        _ = position2.set(row: 6, col: 2)
        diagonal = Diagonal(position1: position1, position2: position2)!
        XCTAssert(diagonal.direction == Diagonal.Direction.toTopRight)
        
        //MARK: Failure Tests
        //not on same diagonal
        _ = position2.set(row: 0, col: 7)
        var NonDiagonal = Diagonal(position1: position1, position2: position2)
        XCTAssert(NonDiagonal == nil)
        
        //pos1 == pos2
        NonDiagonal = Diagonal(position1: position1, position2: position1)
        XCTAssert(NonDiagonal == nil)
    }
    
    func testPositionOnDiagonalAndCol(){
        //Position for diagonal
        guard let position1 = Position(row: 4, col: 4) else {
            XCTFail("Improperly formed position1")
            return
        }
        //diagonal
        var diagonal = Diagonal(position: position1, direction: .toTopLeft)
        //MARK: Top Left Tests
        
        guard let resultPosition1 = Diagonal.positionOn(diagonal, andColumn: 2) else {
            XCTFail("Improperly col argument")
            return
        }
        XCTAssert(Position(row: 2, col: 2)! == resultPosition1, "\(resultPosition1)")

        guard let resultPosition2 = Diagonal.positionOn(diagonal, andColumn: 6) else {
            XCTFail("Improperly col argument")
            return
        }
        XCTAssert(Position(row: 6, col: 6)! == resultPosition2, "\(resultPosition2)")
        
        //MARK: Top Right Tests
        diagonal = Diagonal(position: position1, direction: .toTopRight)
        guard let resultPosition3 = Diagonal.positionOn(diagonal, andColumn: 3) else {
            XCTFail("Improperly col argument")
            return
        }
        XCTAssert(Position(row: 5, col: 3)! == resultPosition3, "\(resultPosition3)")
        
        guard let resultPosition4 = Diagonal.positionOn(diagonal, andColumn: 7) else {
            XCTFail("Improperly col argument")
            return
        }
        XCTAssert(Position(row: 1, col: 7)! == resultPosition4, "\(resultPosition4)")
        
        diagonal = Diagonal(position: Position(row: 5, col: 3)!, direction: .toTopRight)
        guard let resultPosition5 = Diagonal.positionOn(diagonal, andColumn: 4) else {
            XCTFail("Improperly col argument")
            return
        }
        XCTAssert(Position(row: 4, col: 4)! == resultPosition5, "\(resultPosition5)")
        
    }
}
