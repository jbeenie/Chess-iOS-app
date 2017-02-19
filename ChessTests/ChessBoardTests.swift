//
//  ChessBoardTests.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-02-16.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import XCTest
@testable import Chess

class ChessBoardTests: XCTestCase {
    
    
    //chessBoard with no pieces
    let chessBoardEmpty:ChessBoard = ChessBoard()
    
    //chessBoard with pawn at (4,4)
    let chessBoard1:ChessBoard = {
        let chessBoard = ChessBoard()
        let position = Position(row: 4, col: 4)!
        let pawn = Pawn(color: ChessPieceColor.Black, position: position)
        _ = chessBoard.set(piece: pawn, at: position)
        return chessBoard
    }()
    
    //chessBoard with pawns at (3,4), (4,4), (3,5), (4,5)
    let chessBoard2:ChessBoard = {
        let chessBoard = ChessBoard()
        let position1 = Position(row: 3, col: 4)!
        let position2 = Position(row: 4, col: 4)!
        let position3 = Position(row: 3, col: 5)!
        let position4 = Position(row: 4, col: 5)!
        let pawn1 = Pawn(color: ChessPieceColor.Black, position: position1)
        let pawn2 = Pawn(color: ChessPieceColor.Black, position: position2)
        let pawn3 = Pawn(color: ChessPieceColor.Black, position: position3)
        let pawn4 = Pawn(color: ChessPieceColor.Black, position: position4)
        _ = chessBoard.set(piece: pawn1, at: position1)
        _ = chessBoard.set(piece: pawn2, at: position2)
        _ = chessBoard.set(piece: pawn3, at: position3)
        _ = chessBoard.set(piece: pawn4, at: position4)
        return chessBoard
    }()
    
    //chessBoard with 7 pieces: 4 White (Queen, Rook, Knight, Bishop), 3 Black (Queen, Pawn, Knight)
    let chessBoard3:ChessBoard = {
        let chessBoard = ChessBoard()
        let position1 = Position(row: 2, col: 3)!
        let position2 = Position(row: 3, col: 1)!
        let position3 = Position(row: 7, col: 0)!
        let position4 = Position(row: 5, col: 4)!
        let position5 = Position(row: 5, col: 0)!
        let position6 = Position(row: 1, col: 0)!
        let position7 = Position(row: 2, col: 1)!
        
        let rookWhite = Rook(color: ChessPieceColor.White, position: position1)
        let knightWhite = Knight(color: ChessPieceColor.White, position: position2)
        let queenWhite = Queen(color: ChessPieceColor.White, position: position3)
        let bishopWhite = Bishop(color: ChessPieceColor.White, position: position4)
        
        let queenBlack = Rook(color: ChessPieceColor.Black, position: position5)
        let pawnBlack = Knight(color: ChessPieceColor.Black, position: position6)
        let knightBlack = Queen(color: ChessPieceColor.Black, position: position7)
        
        
        _ = chessBoard.set(piece: rookWhite, at: position1)
        _ = chessBoard.set(piece: knightWhite, at: position2)
        _ = chessBoard.set(piece: queenWhite, at: position3)
        _ = chessBoard.set(piece: bishopWhite, at: position4)
        
        _ = chessBoard.set(piece: queenBlack, at: position5)
        _ = chessBoard.set(piece: pawnBlack, at: position6)
        _ = chessBoard.set(piece: knightBlack, at: position7)
        
        return chessBoard
    }()
    
    override func setUp() {
        super.setUp()
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIsRowEmptyBetween() {
        //MARK: - Inclusive = false
        //MARK: non-empty Tests
        XCTAssertFalse( chessBoard1.isRow(4, emptyBetweenColumns: 3, 5))
        XCTAssertFalse( chessBoard1.isRow(4, emptyBetweenColumns: 2, 5))
        XCTAssertFalse( chessBoard1.isRow(4, emptyBetweenColumns: 2, 6))
        XCTAssertFalse( chessBoard1.isRow(4, emptyBetweenColumns: 2, 7))
        //empty tests
        XCTAssert( chessBoard1.isRow(2, emptyBetweenColumns: 3, 5))
        XCTAssert( chessBoard1.isRow(3, emptyBetweenColumns: 2, 5))
        XCTAssert( chessBoard1.isRow(4, emptyBetweenColumns: 0, 4))
        XCTAssert( chessBoard1.isRow(4, emptyBetweenColumns: 0, 3))
        XCTAssert( chessBoard1.isRow(4, emptyBetweenColumns: 4, 7))
        XCTAssert( chessBoard1.isRow(4, emptyBetweenColumns: 5,7))
        XCTAssert( chessBoard1.isRow(4, emptyBetweenColumns: 4, 4))
        
        //MARK: - Inclusive = true
        //MARK: non-empty Tests
        XCTAssertFalse( chessBoard1.isRow(4, emptyBetweenColumns: 3, 5, inclusive: true))
        XCTAssertFalse( chessBoard1.isRow(4, emptyBetweenColumns: 2, 5,inclusive: true))
        XCTAssertFalse( chessBoard1.isRow(4, emptyBetweenColumns: 2, 6,inclusive: true))
        XCTAssertFalse( chessBoard1.isRow(4, emptyBetweenColumns: 2, 7,inclusive: true))
        XCTAssertFalse( chessBoard1.isRow(4, emptyBetweenColumns: 0, 4,inclusive: true))
        XCTAssertFalse( chessBoard1.isRow(4, emptyBetweenColumns: 4, 4,inclusive: true))
        XCTAssertFalse( chessBoard1.isRow(4, emptyBetweenColumns: 4, 7,inclusive: true))

        //empty tests
        XCTAssert( chessBoard1.isRow(2, emptyBetweenColumns: 3, 5,inclusive: true))
        XCTAssert( chessBoard1.isRow(3, emptyBetweenColumns: 2, 5,inclusive: true))
        XCTAssert( chessBoard1.isRow(4, emptyBetweenColumns: 0, 3,inclusive: true))
        XCTAssert( chessBoard1.isRow(4, emptyBetweenColumns: 5,7,inclusive: true))
        
    }
    
    func testIsColumnEmptyBetween() {
        //MARK: - Inclusive = false
        //MARK: non-empty Tests
        XCTAssertFalse( chessBoard1.isColumn(4, emptyBetweenRows: 3, 5))
        XCTAssertFalse( chessBoard1.isColumn(4, emptyBetweenRows: 2, 5))
        XCTAssertFalse( chessBoard1.isColumn(4, emptyBetweenRows: 2, 6))
        XCTAssertFalse( chessBoard1.isColumn(4, emptyBetweenRows: 2, 7))
        //empty tests
        XCTAssert( chessBoard1.isColumn(2, emptyBetweenRows: 3, 5))
        XCTAssert( chessBoard1.isColumn(3, emptyBetweenRows: 2, 5))
        XCTAssert( chessBoard1.isColumn(4, emptyBetweenRows: 0, 4))
        XCTAssert( chessBoard1.isColumn(4, emptyBetweenRows: 0, 3))
        XCTAssert( chessBoard1.isColumn(4, emptyBetweenRows: 4, 7))
        XCTAssert( chessBoard1.isColumn(4, emptyBetweenRows: 5,7))
        XCTAssert( chessBoard1.isColumn(4, emptyBetweenRows: 4, 4))
        
        //MARK: - Inclusive = true
        //MARK: non-empty Tests
        XCTAssertFalse( chessBoard1.isColumn(4, emptyBetweenRows: 3, 5, inclusive: true))
        XCTAssertFalse( chessBoard1.isColumn(4, emptyBetweenRows: 2, 5,inclusive: true))
        XCTAssertFalse( chessBoard1.isColumn(4, emptyBetweenRows: 2, 6,inclusive: true))
        XCTAssertFalse( chessBoard1.isColumn(4, emptyBetweenRows: 2, 7,inclusive: true))
        XCTAssertFalse( chessBoard1.isColumn(4, emptyBetweenRows: 0, 4,inclusive: true))
        XCTAssertFalse( chessBoard1.isColumn(4, emptyBetweenRows: 4, 4,inclusive: true))
        XCTAssertFalse( chessBoard1.isColumn(4, emptyBetweenRows: 4, 7,inclusive: true))
        
        //empty tests
        XCTAssert( chessBoard1.isColumn(2, emptyBetweenRows: 3, 5,inclusive: true))
        XCTAssert( chessBoard1.isColumn(3, emptyBetweenRows: 2, 5,inclusive: true))
        XCTAssert( chessBoard1.isColumn(4, emptyBetweenRows: 0, 3,inclusive: true))
        XCTAssert( chessBoard1.isColumn(4, emptyBetweenRows: 5,7,inclusive: true))
    }
    
    func testIsDiagonalEmptyBetween() {
        //MARK: - Inclusive = false
        //MARK: non-empty Tests
        guard var position1 = Position(row: 3, col: 3) else {
            XCTFail("Improperly formed position1")
            return
        }
        guard var position2 = Position(row: 5, col: 5) else {
            XCTFail("Improperly formed position2")
            return
        }
        guard var diagonal = Diagonal(position1: position1, position2: position2) else{
            XCTFail("Improperly formed diagonal")
            return
        }
        XCTAssertFalse( chessBoard1.isDiagonal(diagonal, emptyBetweenColumns: position1.col, position2.col))
        
        _ = position1.set(row: 2, col: 2)
        _ = position2.set(row: 6, col: 6)
        diagonal = Diagonal(position1: position1, position2: position2)!
        XCTAssertFalse( chessBoard1.isDiagonal(diagonal, emptyBetweenColumns: position1.col, position2.col))
        
        _ = position1.set(row: 5, col: 3)
        _ = position2.set(row: 2, col: 6)
        diagonal = Diagonal(position1: position1, position2: position2)!
        XCTAssertFalse( chessBoard1.isDiagonal(diagonal, emptyBetweenColumns: position1.col, position2.col))
        
        _ = position1.set(row: 6, col: 2)
        _ = position2.set(row: 2, col: 6)
        diagonal = Diagonal(position1: position1, position2: position2)!
        XCTAssertFalse( chessBoard1.isDiagonal(diagonal, emptyBetweenColumns: position1.col, position2.col))
        
        //MARK: ChessBoard 2
        _ = position1.set(row: 4, col: 4)
        _ = position2.set(row: 2, col: 6)
        diagonal = Diagonal(position1: position1, position2: position2)!
        XCTAssertFalse( chessBoard2.isDiagonal(diagonal, emptyBetweenColumns: position1.col, position2.col))
        
        
        _ = position1.set(row: 6, col: 2)
        _ = position2.set(row: 2, col: 6)
        diagonal = Diagonal(position1: position1, position2: position2)!
        XCTAssertFalse( chessBoard2.isDiagonal(diagonal, emptyBetweenColumns: position1.col, position2.col))
        
        //empty tests
        
        _ = position1.set(row: 3, col: 3)
        _ = position2.set(row: 5, col: 5)
        XCTAssert( chessBoardEmpty.isDiagonal(diagonal, emptyBetweenColumns: position1.col, position2.col))
        
        _ = position1.set(row: 2, col: 2)
        _ = position2.set(row: 6, col: 6)
        diagonal = Diagonal(position1: position1, position2: position2)!
        XCTAssert( chessBoardEmpty.isDiagonal(diagonal, emptyBetweenColumns: position1.col, position2.col))
        
        _ = position1.set(row: 5, col: 3)
        _ = position2.set(row: 2, col: 6)
        diagonal = Diagonal(position1: position1, position2: position2)!
        XCTAssert( chessBoardEmpty.isDiagonal(diagonal, emptyBetweenColumns: position1.col, position2.col))
        
        _ = position1.set(row: 6, col: 2)
        _ = position2.set(row: 2, col: 6)
        diagonal = Diagonal(position1: position1, position2: position2)!
        XCTAssert( chessBoardEmpty.isDiagonal(diagonal, emptyBetweenColumns: position1.col, position2.col))
        
        
        //MARK: - Inclusive = true
        //MARK: non-empty Tests
        _ = position1.set(row: 3, col: 3)
        _ = position2.set(row: 5, col: 5)
        XCTAssertFalse( chessBoard1.isDiagonal(diagonal, emptyBetweenColumns: position1.col, position2.col, inclusive: true))
        
        _ = position1.set(row: 2, col: 2)
        _ = position2.set(row: 6, col: 6)
        diagonal = Diagonal(position1: position1, position2: position2)!
        XCTAssertFalse( chessBoard1.isDiagonal(diagonal, emptyBetweenColumns: position1.col, position2.col, inclusive: true))
        
        _ = position1.set(row: 5, col: 3)
        _ = position2.set(row: 2, col: 6)
        diagonal = Diagonal(position1: position1, position2: position2)!
        XCTAssertFalse( chessBoard1.isDiagonal(diagonal, emptyBetweenColumns: position1.col, position2.col, inclusive: true))
        
        _ = position1.set(row: 6, col: 2)
        _ = position2.set(row: 2, col: 6)
        diagonal = Diagonal(position1: position1, position2: position2)!
        XCTAssertFalse( chessBoard1.isDiagonal(diagonal, emptyBetweenColumns: position1.col, position2.col, inclusive: true))
        
        
        _ = position1.set(row: 4, col: 4)
        _ = position2.set(row: 2, col: 6)
        diagonal = Diagonal(position1: position1, position2: position2)!
        XCTAssertFalse( chessBoard1.isDiagonal(diagonal, emptyBetweenColumns: position1.col, position2.col, inclusive: true))
        
        _ = position1.set(row: 6, col: 2)
        _ = position2.set(row: 4, col: 4)
        diagonal = Diagonal(position1: position1, position2: position2)!
        XCTAssertFalse( chessBoard1.isDiagonal(diagonal, emptyBetweenColumns: position1.col, position2.col, inclusive: true))
        
        //MARK: ChessBoard2
        
        _ = position1.set(row: 3, col: 5)
        _ = position2.set(row: 4, col: 4)
        diagonal = Diagonal(position1: position1, position2: position2)!
        XCTAssertFalse( chessBoard2.isDiagonal(diagonal, emptyBetweenColumns: position1.col, position2.col, inclusive: true))
        
        _ = position1.set(row: 2, col: 6)
        _ = position2.set(row: 4, col: 4)
        diagonal = Diagonal(position1: position1, position2: position2)!
        XCTAssertFalse( chessBoard2.isDiagonal(diagonal, emptyBetweenColumns: position1.col, position2.col, inclusive: true))
        
        _ = position1.set(row: 2, col: 6)
        _ = position2.set(row: 6, col: 2)
        diagonal = Diagonal(position1: position1, position2: position2)!
        XCTAssertFalse( chessBoard2.isDiagonal(diagonal, emptyBetweenColumns: position1.col, position2.col, inclusive: true))
        
        
        
        
        //MARK: empty tests
        _ = position1.set(row: 3, col: 3)
        _ = position2.set(row: 5, col: 5)
        XCTAssert( chessBoardEmpty.isDiagonal(diagonal, emptyBetweenColumns: position1.col, position2.col, inclusive: true))
        
        _ = position1.set(row: 2, col: 2)
        _ = position2.set(row: 6, col: 6)
        diagonal = Diagonal(position1: position1, position2: position2)!
        XCTAssert( chessBoardEmpty.isDiagonal(diagonal, emptyBetweenColumns: position1.col, position2.col, inclusive: true))
        
        _ = position1.set(row: 5, col: 3)
        _ = position2.set(row: 2, col: 6)
        diagonal = Diagonal(position1: position1, position2: position2)!
        XCTAssert( chessBoardEmpty.isDiagonal(diagonal, emptyBetweenColumns: position1.col, position2.col, inclusive: true))
        
        _ = position1.set(row: 6, col: 2)
        _ = position2.set(row: 2, col: 6)
        diagonal = Diagonal(position1: position1, position2: position2)!
        XCTAssert( chessBoardEmpty.isDiagonal(diagonal, emptyBetweenColumns: position1.col, position2.col, inclusive: true))
        
        
        _ = position1.set(row: 4, col: 4)
        _ = position2.set(row: 2, col: 6)
        diagonal = Diagonal(position1: position1, position2: position2)!
        XCTAssert( chessBoardEmpty.isDiagonal(diagonal, emptyBetweenColumns: position1.col, position2.col, inclusive: true))
        
        _ = position1.set(row: 6, col: 2)
        _ = position2.set(row: 4, col: 4)
        diagonal = Diagonal(position1: position1, position2: position2)!
        XCTAssert( chessBoardEmpty.isDiagonal(diagonal, emptyBetweenColumns: position1.col, position2.col, inclusive: true))
        
        //MARK: ChessBoard2
        
        _ = position1.set(row: 3, col: 5)
        _ = position2.set(row: 4, col: 4)
        diagonal = Diagonal(position1: position1, position2: position2)!
        XCTAssert( chessBoardEmpty.isDiagonal(diagonal, emptyBetweenColumns: position1.col, position2.col, inclusive: true))
        
        _ = position1.set(row: 2, col: 6)
        _ = position2.set(row: 4, col: 4)
        diagonal = Diagonal(position1: position1, position2: position2)!
        XCTAssert( chessBoardEmpty.isDiagonal(diagonal, emptyBetweenColumns: position1.col, position2.col, inclusive: true))
        
        _ = position1.set(row: 2, col: 6)
        _ = position2.set(row: 6, col: 2)
        diagonal = Diagonal(position1: position1, position2: position2)!
        XCTAssert( chessBoardEmpty.isDiagonal(diagonal, emptyBetweenColumns: position1.col, position2.col, inclusive: true))
        
    }
    
    func testPiecesOnBoardOfColor(){
        let black = ChessPieceColor.Black
        let white = ChessPieceColor.White
        print("*****************************")
        print("black pieces")
        print("ChessBoard1:")
        print(chessBoard1.piecesOnBoard(ofColor: black))
        print("ChessBoard2:")
        print(chessBoard2.piecesOnBoard(ofColor: black))
        print()
        print("white pieces")
        print("ChessBoard1:")
        print(chessBoard1.piecesOnBoard(ofColor: white))
        print("ChessBoard2:")
        print(chessBoard2.piecesOnBoard(ofColor: white))
        print("*****************************")
    }
    
    func testIsSquareUnderAttack(){
        let black = ChessPieceColor.Black
        let white = ChessPieceColor.White
        //chessBoard1
        //should be under attack
        let position1 = Position(row: 5, col: 3)!
        let position2 = Position(row: 5, col: 5)!
        //shouldn't be under attack
        let position3 = Position(row: 5, col: 4)!
        let position4 = Position(row: 0, col: 0)!
        let position5 = Position(row: 3, col: 3)!
        let position6 = Position(row: 3, col: 5)!
        
        //chessBoard3
        //should be under attack
        let position7 = Position(row: 1, col: 0)!
        let position8 = Position(row: 1, col: 2)!
        let position9 = Position(row: 5, col: 0)!
        let position10 = Position(row: 2, col: 1)!        
        let position11 = Position(row: 0, col: 3)!
        let position12 = Position(row: 0, col: 7)!
        //shouldn't be under attack
        let position13 = Position(row: 0, col: 1)!
        let position14 = Position(row: 0, col: 0)!
        let position15 = Position(row: 4, col: 0)!
        
        
        //chessBoard1
        XCTAssert(chessBoard1.isSquareUnderAttack(at: position1, from: black))
        XCTAssert(chessBoard1.isSquareUnderAttack(at: position2, from: black))
        
        XCTAssertFalse(chessBoard1.isSquareUnderAttack(at: position3, from: black))
        XCTAssertFalse(chessBoard1.isSquareUnderAttack(at: position4, from: black))
        XCTAssertFalse(chessBoard1.isSquareUnderAttack(at: position5, from: black))
        XCTAssertFalse(chessBoard1.isSquareUnderAttack(at: position6, from: black))
        
        //chessBoard3
        XCTAssert(chessBoard3.isSquareUnderAttack(at: position7, from: white))
        XCTAssert(chessBoard3.isSquareUnderAttack(at: position8, from: white))
        XCTAssert(chessBoard3.isSquareUnderAttack(at: position9, from: white))
        XCTAssert(chessBoard3.isSquareUnderAttack(at: position10, from: white))
        XCTAssert(chessBoard3.isSquareUnderAttack(at: position11, from: white))
        XCTAssert(chessBoard3.isSquareUnderAttack(at: position12, from: white))
        
        
        XCTAssertFalse(chessBoard3.isSquareUnderAttack(at: position13, from: white))
        XCTAssertFalse(chessBoard3.isSquareUnderAttack(at: position14, from: white))
        XCTAssertFalse(chessBoard3.isSquareUnderAttack(at: position15, from: white))
    }
   
    
}
