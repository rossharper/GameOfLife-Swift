//
//  LifeTest.swift
//  gameoflife
//
//  Created by Ross Harper on 24/02/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

import XCTest

class LifeTest : XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testInitialCellsAreAliveBeforeEvolution() {
        let life = Life(initialLiveCells: [Cell(x: 1, y: 0), Cell(x: 0, y: 1)])
        
        XCTAssertTrue(life.cellIsAlive(Cell(x: 1, y: 0)))
        XCTAssertTrue(life.cellIsAlive(Cell(x: 0, y: 1)))
    }
    
    func testInitiallyDeadCellsAreDeadBeforeEvolution() {
        let life = Life(initialLiveCells: [Cell(x: 1, y: 0), Cell(x: 0, y: 1)])
        
        XCTAssertFalse(life.cellIsAlive(Cell(x: 0, y: 0)))
        XCTAssertFalse(life.cellIsAlive(Cell(x: 1, y: 1)))
    }
    
    func testLiveCellWithFewerThanTwoNeighboursShouldDie() {
        var life = Life(initialLiveCells: [Cell(x: 1, y: 0), Cell(x: 0, y: 1)])
        
        life = life.evolve()
        
        XCTAssertFalse(life.cellIsAlive(Cell(x:1, y: 0)))
        XCTAssertFalse(life.cellIsAlive(Cell(x:0, y: 1)))
    }
    
    func testLiveCellWithTwoLiveNeighboursShouldSurvive() {
        var life = Life(initialLiveCells: [Cell(x: 1, y: 0), Cell(x: 0, y: 1), Cell(x: 2, y: 1)])
        
        life = life.evolve()
        
        XCTAssertTrue(life.cellIsAlive(Cell(x: 1, y: 0)))
    }
    
    func testLiveCellWithThreeLiveNeighboursShouldSurvive() {
        var life = Life(initialLiveCells: [Cell(x: 1, y: 0), Cell(x: 0, y: 1), Cell(x: 2, y: 1), Cell(x: 2, y: 0)])
        
        life = life.evolve()
        
        XCTAssertTrue(life.cellIsAlive(Cell(x: 1, y: 0)))
    }
    
    func testLiveCellWithMoreThanThreeLiveNeighboursShouldDie() {
        var life = Life(initialLiveCells: [Cell(x: 1, y: 0), Cell(x: 0, y: 1), Cell(x: 2, y: 1), Cell(x: 2, y: 0), Cell(x: 1, y: 1)])
        
        life = life.evolve()
        
        XCTAssertFalse(life.cellIsAlive(Cell(x: 1, y: 0)))
    }
    
    func testNewCellIsBornWhenThreeLiveNeighbours() {
        var life = Life(initialLiveCells: [Cell(x: 0, y: 0), Cell(x:1, y:0), Cell(x: 2, y: 0)])
        
        life = life.evolve()
        
        XCTAssertTrue(life.cellIsAlive(Cell(x: 1, y: 1)))
    }
    
    func testNoLifeEvolvedResultsInNoLife() {
        var life = Life(initialLiveCells: [])
        
        life = life.evolve()
        
        for x in (0 ... 50) {
            for y in (0 ... 50) {
                XCTAssertFalse(life.cellIsAlive(Cell(x: x, y: y)))
            }
        }
    }
    
    // TODO: my solution allows life beyond borders... test and kill!
    
    func testBlinkerOscillator() {
        let verticalBlinker =   Set<Cell>([Cell(x: 1, y: 0), Cell(x: 1, y: 1), Cell(x: 1, y: 2)])
        let horizontalBlinker = Set<Cell>([Cell(x: 0, y: 1), Cell(x: 1, y: 1), Cell(x: 2, y: 1)])
        
        var life = Life(initialLiveCells: horizontalBlinker)
        
        life = life.evolve()
        
        XCTAssertTrue(life.liveCells == verticalBlinker)
        
        life = life.evolve()
        
        XCTAssertTrue(life.liveCells == horizontalBlinker)
    }
}
