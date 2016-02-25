//
//  CellTest.swift
//  gameoflife
//
//  Created by Ross Harper on 24/02/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

import Foundation

import XCTest

class CellTest : XCTestCase {
    
    func testEquality() {
        let cell1 = Cell(x: 1, y: 2)
        let cell2 = Cell(x: 1, y: 2)
        
        XCTAssertEqual(cell1, cell2)
    }
    
    func testInequality() {
        let cell1 = Cell(x: 1, y: 2);
        let cell2 = Cell(x: 1, y: 3);
        
        XCTAssertNotEqual(cell1, cell2)
        
        let cell3 = Cell(x: 0, y: 2)
        let cell4 = Cell(x: 1, y: 2)
        
        XCTAssertNotEqual(cell3, cell4)
    }
    
    func testHash() {
        XCTAssertEqual(Cell(x: 1, y: 1).hashValue, Cell(x: 1, y: 1).hashValue)
        
        var cellSet = Set<Cell>()
        cellSet.insert(Cell(x: 1, y: 1))
        cellSet.insert(Cell(x: 1, y: 1))
        cellSet.insert(Cell(x: 2, y: 2))
        
        XCTAssertEqual(2, cellSet.count)
    }
    
    func testSetsOfSameCellsAreEqual() {
        var setOfCells1 = Set<Cell>()
        setOfCells1.insert(Cell(x: 1, y: 1))
        
        var setOfCells2 = Set<Cell>()
        setOfCells2.insert(Cell(x: 1, y: 1))
        
        XCTAssertEqual(setOfCells1, setOfCells2)
    }
}