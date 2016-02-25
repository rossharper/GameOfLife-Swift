//
//  Life.swift
//  gameoflife
//
//  Created by Ross Harper on 24/02/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

import Foundation

struct Life {
    
    let liveCells : Set<Cell>
    
    init(initialLiveCells: Set<Cell>) {
        self.liveCells = initialLiveCells
    }
    
    func evolve() -> Life {
        let cellsThatShouldDie = getCellsThatShouldDie()
        
        let cellsThatShouldBeBorn = getCellsThatShouldBeBorn()
        
        return Life(initialLiveCells: liveCells.subtract(cellsThatShouldDie).union(cellsThatShouldBeBorn))
    }
    
    func cellIsAlive(cell: Cell) -> Bool {
        return liveCells.contains(cell)
    }
    
    private func getCellsThatShouldBeBorn() -> Set<Cell> {
        return Set(liveCells.flatMap { self.deadNeighboursOf($0) }.filter { numberOfLivingNeighboursOf($0) == 3 })
    }
    
    private func getCellsThatShouldDie() -> Set<Cell> {
        return Set(liveCells.filter { !(2 ... 3 ~= numberOfLivingNeighboursOf($0)) })
    }
    
    private func numberOfLivingNeighboursOf(cell: Cell) -> Int {
        return livingNeighboursOf(cell).count
    }
    
    private func livingNeighboursOf(cell: Cell) -> Set<Cell> {
        return Set(neighboursOf(cell).filter { cellIsAlive($0) })
    }
    
    private func deadNeighboursOf(cell: Cell) -> Set<Cell> {
        return Set(neighboursOf(cell).filter { !cellIsAlive($0) })
    }
    
    private func neighboursOf(cell: Cell) -> Set<Cell> {
        var neighbours = Set<Cell>()
        for x in (-1 ... 1) {
            for y in (-1 ... 1) {
                if x != 0 || y != 0 {
                    neighbours.insert(Cell(x: cell.x + x, y: cell.y + y))
                }
            }
        }
        return neighbours
    }
}
