//
//  ChessPieceTests.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-22.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import XCTest
@testable import Chess

class ChessPieceTests: XCTestCase {
    
    let chessBoard = ChessBoard()
    
    let positionR = Position(row: 2, col: 3)!
    let positionKn = Position(row: 3, col: 1)!
    let positionQ = Position(row: 7, col: 0)!
    let positionB = Position(row: 5, col: 4)!
    let positionK = Position(row: 5, col: 0)!
    let positionPB = Position(row: 4, col: 7)!
    let positionPW = Position(row: 4, col: 4)!
    
    lazy var rook:Rook = {Rook(color: ChessPieceColor.White, position: self.positionR, chessBoard:self.chessBoard)}()
    lazy var knight:Knight = {Knight(color: ChessPieceColor.White, position: self.positionKn,chessBoard:self.chessBoard)}()
    lazy var queen:Queen = {Queen(color: ChessPieceColor.White, position: self.positionQ,chessBoard:self.chessBoard)}()
    lazy var bishop:Bishop = {Bishop(color: ChessPieceColor.White, position: self.positionB,chessBoard:self.chessBoard)}()
    
    lazy var king:King = {King(color: ChessPieceColor.White, position: self.positionK,chessBoard:self.chessBoard)}()
    lazy var pawnWhite:Pawn = {Pawn(color: ChessPieceColor.White, position: self.positionPW,chessBoard:self.chessBoard)}()
    lazy var pawnBlack:Pawn = {Pawn(color: ChessPieceColor.Black, position: self.positionPB,chessBoard:self.chessBoard)}()

    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReachableSquaresPawnWhite() {
        pawnWhite.hasMoved = false
        XCTAssert(pawnWhite.reachableSquares.count == 4)
        pawnWhite.hasMoved = true
        XCTAssert(pawnWhite.reachableSquares.count == 3)
        print(pawnWhite.reachableSquares)
    }
    
    func testReachableSquaresPawnBlack() {
        pawnBlack.hasMoved = false
        XCTAssert(pawnBlack.reachableSquares.count == 3)
        pawnBlack.hasMoved = true
        XCTAssert(pawnBlack.reachableSquares.count == 2)
        print(pawnBlack.reachableSquares)
    }
    
    func testReachableSquaresRook() {
        XCTAssert(rook.reachableSquares.count == 14)
        print(rook.reachableSquares)
    }
    
    func testReachableSquaresQueen() {
        XCTAssert(queen.reachableSquares.count == 21)
        print(queen.reachableSquares)
    }
    
    func testReachableSquaresBishop() {
        XCTAssert(bishop.reachableSquares.count == 11)
        print(bishop.reachableSquares)
    }
    
    func testReachableSquaresKnight() {
        XCTAssert(knight.reachableSquares.count == 6)
        print(knight.reachableSquares)
    }
    
    func testReachableSquaresKing() {
        XCTAssert(king.reachableSquares.count == 5)
        print(king.reachableSquares)
    }
}
