//
//  ViewController.swift
//  GameOfLife
//
//  Created by Ross Harper on 25/02/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {
    
    var delayBetweenGenerations : Float = 0.5
    let numRows = 32
    var runButton : UIButton!
    var resetButton : UIButton!
    var speedSelector : UISlider!
    var universeCollectionView: UICollectionView!
    var evolving = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = self.view.frame
        
        runButton = UIButton(type: UIButtonType.RoundedRect)
        runButton.translatesAutoresizingMaskIntoConstraints = false
        runButton.setTitle("Evolve!", forState: .Normal)
        runButton.setTitle("Pause Evolution", forState: .Selected)
        runButton.setTitleColor(UIColor.greenColor(), forState: .Normal)
        runButton.setTitleColor(UIColor.redColor(), forState: .Selected)
        runButton.addTarget(self, action: "onEvolvePressed:", forControlEvents: .TouchUpInside)
        self.view.addSubview(runButton)
        self.view.addConstraint(NSLayoutConstraint(item: runButton, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 20.0))
        self.view.addConstraint(NSLayoutConstraint(item: runButton, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: -10.0))
        self.view.addConstraint(NSLayoutConstraint(item: runButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -20.0))
        self.view.addConstraint(NSLayoutConstraint(item: runButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -60.0))
        
        resetButton = UIButton(type: UIButtonType.RoundedRect)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.setTitle("Reset", forState: .Normal)
        resetButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        resetButton.addTarget(self, action: "onResetPressed:", forControlEvents: .TouchUpInside)
        self.view.addSubview(resetButton)
        self.view.addConstraint(NSLayoutConstraint(item: resetButton, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 10.0))
        self.view.addConstraint(NSLayoutConstraint(item: resetButton, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: -20.0))
        self.view.addConstraint(NSLayoutConstraint(item: resetButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -20.0))
        self.view.addConstraint(NSLayoutConstraint(item: resetButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -60.0))
        
        speedSelector = UISlider()
        speedSelector.translatesAutoresizingMaskIntoConstraints = false
        speedSelector.minimumValue = 0.0
        speedSelector.maximumValue = 1.9
        speedSelector.value = 2.0 - delayBetweenGenerations
        speedSelector.addTarget(self, action: "onSpeedChanged:", forControlEvents: .ValueChanged)
        self.view.addSubview(speedSelector)
        self.view.addConstraint(NSLayoutConstraint(item: speedSelector, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 20.0))
        self.view.addConstraint(NSLayoutConstraint(item: speedSelector, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: -20.0))
        self.view.addConstraint(NSLayoutConstraint(item: speedSelector, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: runButton, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: -20.0))
        self.view.addConstraint(NSLayoutConstraint(item: speedSelector, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: runButton, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: -60.0))
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        let cellDimension = (frame.width > frame.height) ? frame.height : frame.width
        let cellSize = CGSize(width: (cellDimension / CGFloat(numRows)), height: (cellDimension / CGFloat(numRows)))
        layout.itemSize = cellSize
        
        universeCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        universeCollectionView.backgroundColor = UIColor.whiteColor()
        universeCollectionView.dataSource = self
        universeCollectionView.registerClass(CellCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        universeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        universeCollectionView.allowsMultipleSelection = true
        self.view.addSubview(universeCollectionView)
        
        let aspectConstraint = NSLayoutConstraint(item: universeCollectionView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: universeCollectionView, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0.0)
        aspectConstraint.priority = 1000
        self.view.addConstraint(aspectConstraint)

        let centerXconstraint = NSLayoutConstraint(item: universeCollectionView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0)
        centerXconstraint.priority = 1000
        self.view.addConstraint(centerXconstraint)
        
        let centerYconstraint = NSLayoutConstraint(item: universeCollectionView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0)
        centerYconstraint.priority = 1000
        self.view.addConstraint(centerYconstraint)
        
        let topConstraint = NSLayoutConstraint(item: universeCollectionView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0)
        topConstraint.priority = 500
        self.view.addConstraint(topConstraint)
        
        let bottomConstraint = NSLayoutConstraint(item: universeCollectionView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: runButton, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: -20.0)
        bottomConstraint.priority = 500
        self.view.addConstraint(bottomConstraint)
        
        let leadingConstraint = NSLayoutConstraint(item: universeCollectionView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0.0)
        leadingConstraint.priority = 500
        self.view.addConstraint(leadingConstraint)
        
        let trailingConstraint = NSLayoutConstraint(item: universeCollectionView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0.0)
        trailingConstraint.priority = 500
        self.view.addConstraint(trailingConstraint)
    }
    
    @objc func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return numRows
    }
    
    @objc func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numRows
    }
    
    @objc func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onSpeedChanged(sender: UISlider!) {
        delayBetweenGenerations = 2.0 - sender.value
    }
    
    func onEvolvePressed(sender: UIButton!) {
        runButton.selected = !runButton.selected
        toggleEvolution()
    }
    
    func onResetPressed(sender: UIButton!) {
        stopEvolution()
        clearUniverse()
        runButton.selected = false
    }
    
    private func toggleEvolution() {
        if evolving {
            stopEvolution()
        }
        else {
            startEvolution()
        }
    }
    
    private func startEvolution() {
        evolving = true
        evolve()
    }
    
    private func stopEvolution() {
        evolving = false
    }
    
    private func clearUniverse() {
        for indexPath in universeCollectionView.indexPathsForSelectedItems()! {
            universeCollectionView.deselectItemAtIndexPath(indexPath, animated: true)
        }
    }
    
    private func evolve() {
        if evolving {
            let selectedCells = universeCollectionView.indexPathsForSelectedItems()!
            let livingCells : Set<Cell> = Set(selectedCells.map {
                Cell(x: $0.item, y: $0.section)
                })
            var life = Life(initialLiveCells: livingCells)
            life = life.evolve()
            clearUniverse()
            for cell in life.liveCells {
                if 0..<numRows ~= cell.x && 0..<numRows ~= cell.y {
                    universeCollectionView.selectItemAtIndexPath(NSIndexPath(forItem: cell.x, inSection: cell.y), animated: true, scrollPosition: .None)
                }
            }
            delay(Double(delayBetweenGenerations), closure: {self.evolve()})
        }
    }
    
    private func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}

