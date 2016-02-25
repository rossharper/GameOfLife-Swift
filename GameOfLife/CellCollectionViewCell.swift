//
//  CellCollectionViewCell.swift
//  gameoflife
//
//  Created by Ross Harper on 25/02/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

import UIKit

class CellCollectionViewCell : UICollectionViewCell {

    override var selected : Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @objc override func drawRect(rect: CGRect) {
        super.drawRect(rect);
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetRGBFillColor(context, 0.8, 0.8, 0.8, 1)
        CGContextFillRect(context, self.bounds)
        
        if (self.selected) {
            CGContextSetRGBFillColor(context, 0, 1, 0, 1)
        }
        else {
            CGContextSetRGBFillColor(context, 1, 1, 1, 1)
        }
        CGContextFillRect(context, self.bounds.insetBy(dx: CGFloat(1.0), dy: CGFloat(1.0)))
    }
}
