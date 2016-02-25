//
//  Cell.swift
//  gameoflife
//
//  Created by Ross Harper on 24/02/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

import Foundation

class Cell : Hashable {
    
    var x : Int
    var y : Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    var hashValue : Int {
        get {
            return (31 * (31 + x) + y);
        }
    }
}

func ==(lhs: Cell, rhs: Cell) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}